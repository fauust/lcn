#!/usr/bin/env bash

virt-install --connect=qemu:///system \
  --name=vm_2 \
  --vcpus=2 \
  --memory=2048 \
  --location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
  --disk size=5 \
  --noautoconsole \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --autostart \
  --wait