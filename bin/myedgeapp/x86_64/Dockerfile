FROM traefik:latest

LABEL maintainer="Paulo Truta paulo@edgebox.io"

# Install wget and install/updates certificates
RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
    curl \
    git \
    tinc \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

# Install tinc-boot
RUN curl -L https://github.com/reddec/tinc-boot/releases/latest/download/tinc-boot_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ tinc-boot \
    && rm tinc-boot_linux_amd64.tar.gz

RUN source /etc/tinc/tinc_boot.token && tinc-boot gen --prefix 10.10.10.1 --standaline -a $BOOTNODE_IP \
    && systemctl start tinc@dnet \
    && systemctl enable tinc@dnet \
    && sudo tinc-boot bootnode --service --token $BOOTNODE_TOKEN \
    systemctl start tinc-boot-dnet \
    systemctl enable tinc-boot-dnet

ENV DOCKER_HOST unix:///tmp/docker.sock
