#!/usr/bin/env bash

virt-install --name=vm-try01 \
  --vcpus=2 \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --initrd-inject=id_ed25519.pub \
  --noautoconsole \
  --memory=2048 \
  --location /home/jon/Downloads/debian-12.5.0-amd64-netinst.iso \
  --disk size=10 \
  --os-variant=debian12 \
  --wait -1


# sleep ?A
nc # man nc attendre que le port 22 réponde

# install apache
scp install...
ssh vm ./install_apachekk
