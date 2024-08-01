# 1. Iteration 1
    
##    1. Installation de Docker et révision.
    
    Docker installation could be performed simply by running some commands (i) but I am going to do it with Ansible (ii)

###         i. Installing with a shell script

A Docker installa tion script is available at : [scripts/installDocker.sh](scripts/installDocker.sh)

###         ii. Installation with an Ansible role


##    2. Container simple et datas

```bash
FROM debian:12-slim

RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      bash \
      iperf \
      iproute2 \
      iputils-ping \
      less \
      mtr \
      telnet \
    && rm -rf /var/lib/apt/lists/* \
      /var/cache/debconf/* \
    && apt-get clean

CMD ["/usr/bin/bash"]
```