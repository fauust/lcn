#!/usr/bin/env bash

virt-install --name=vm-try01 \
  --vcpus=4 \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --initrd-inject=id_ed25519.pub \
  --noautoconsole \
  --memory=4096 \
  --location /home/jon/Downloads/debian-12.5.0-amd64-netinst.iso \
  --disk size=10 \
  --os-variant=debian12 \
  --wait -1

