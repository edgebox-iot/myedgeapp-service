FROM debian:latest

COPY --from=traefik:v1.7.28-alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=traefik:v1.7.28-alpine /usr/share/zoneinfo /usr/share/
COPY --from=traefik:v1.7.28-alpine /usr/local/bin/traefik /

LABEL maintainer="Paulo Truta paulo@edgebox.io"

# Install wget and install/updates certificates
RUN apt-get update && apt-get install -y \
    ca-certificates \
    tzdata \
    wget \
    curl \
    git \
    tinc

# Install tinc-boot
RUN curl -L https://github.com/reddec/tinc-boot/releases/latest/download/tinc-boot_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ tinc-boot

# Copy the Boot Token (Git Ignored. Generated as Secret on Build or available as file locally)
COPY ./tinc_boot.token /etc/tinc/tinc_boot.token

# Start tinc-boot and auto exchange key service
RUN . /etc/tinc/tinc_boot.token tinc-boot gen --prefix 10.10.10.1 --standaline -a $BOOTNODE_IP \
#    && systemctl start tinc@dnet \
#    && systemctl enable tinc@dnet \
#    && sudo tinc-boot bootnode --service --token $BOOTNODE_TOKEN \
#    systemctl start tinc-boot-dnet \
#    systemctl enable tinc-boot-dnet

ENV DOCKER_HOST unix:///tmp/docker.sock

EXPOSE 80
VOLUME ["/tmp"]
ENTRYPOINT ["/traefik"]
