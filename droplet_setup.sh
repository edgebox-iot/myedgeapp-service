#!/bin/sh
set -e

PROGNAME=$(basename $0)

# These should be tweaked accoording to the needs of the setup
IS_BOOTNODE="True"
PREFIX="10.10.10.1"
BOOTNODE_IP="157.230.110.104"

die() {
    echo "$PROGNAME: $*" >&2
    exit 1
}

echo << EOF

------------------------------------------------------------------------
|  Setup script for fresh installation of myedgeapp instance droplet   |
------------------------------------------------------------------------

EOF

echo " -> Installing tinc"
apt-get install -y tinc

echo " -> Installing and generating tinc-boot connfiguration"
curl -L https://github.com/reddec/tinc-boot/releases/latest/download/tinc-boot_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ tinc-boot

if [ "$IS_BOOTNODE" = "True" ]; then
    STANDALONE_OP = "--standalone"
    CLIENT_OP = ""
else
    STANDALONE_OP = ""
    CLIENT_OP = "--token $BOOTNODE_TOKEN"
fi

sudo tinc-boot gen --prefix $PREFIX $STANDALONE_OP$CLIENT_OP -a $BOOTNODE_IP

systemctl start tinc@dnet
systemctl enable tinc@dnet

if [ "$IS_BOOTNODE" = "True" ]; then

    echo " -> Setting up tinc-boot bootnode setup (prefix: 10.10.10.1)"
    sudo tinc-boot bootnode --service --token $BOOTNODE_TOKEN # Should be a deploy defined secret passed as env

    systemctl start tinc-boot-dnet
    systemctl enable tinc-boot-dnet

fi

echo " -> Installing etcd"
ETCD_VER=v3.4.14
# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

mv /tmp/etcd-download-test/etc* /usr/local/bin

etcd --version
etcdctl version

# TODO: Find if is boot node or slave node and configure appropriately. Right now runs always as standalone.

killall etcd
sleep 5
nohup etcd > logs/etcd.log &

echo " -> Installing traefik"
wget --quiet -O /usr/local/bin/traefik "https://github.com/traefik/traefik/releases/download/v2.4.2/traefik_linux-amd64"
chmod +x /usr/local/bin/traefik

echo " -> Setting traefik config files"
mkdir /etc/traefik
cp ./config/traefik* /etc/traefik/

killall traefik
sleep 5
nohup traefik > logs/traefik.log &

# This is enough to get the tunnel setup and auto-handshake + key exchange possible.
# Next steps are:
# - Automatically call the edgebox.io API to get the bootnode ip
# - Automatically call the edgebox.io API to get a prefix ip (if not boot node)
