#!/usr/bin/env bash

virt-install\
  --connect=qemu:///system \
  --name=VM\
  --memory=4096\
  --vcpus=4\
  --initrd-inject=preseed.cfg\
  --initrd-inject=commandevm.sh\
  --initrd-inject=installapache.sh\
  --noautoconsole\
	--location=/home/thouvenot/Téléchargements/debian-12.5.0-amd64-netinst.iso\
	--graphics=spice\
	--noautoconsole \
  --autostart \
	--wait


