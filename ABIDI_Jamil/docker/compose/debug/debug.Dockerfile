FROM ubuntu:24.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    wget \
    net-tools \
    iproute2 \
    dnsutils \
    tcpdump \
    iputils-ping \
    telnet \
    traceroute \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

CMD ["sleep", "infinity"]
# CMD ["tail", "-f", "/dev/null"]