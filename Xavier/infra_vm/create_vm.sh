#!/bin/bash
virt-install \
--connect=qemu:///system \
--initrd-inject=preseed.cfg \
--initrd-inject=postinst.sh \
--disk pool=default,size=4,bus=virtio,format=qcow2 \
--name deb \
--memory 2048 \
--vcpus 3 \
--os-variant=debian12 \
--virt-type=kvm \
--network default,model=virtio \
--graphics none \
--noautoconsole \
--wait -1 \
--location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
--extra-args="auto console=ttyS0, 115200n8 serial"				\

## Explications :
# --noautoconsole : ne pas se connecter directement dans la console
#                   (suivre l'installation à partir du virt-manager).
# --wait -1 : permet à virt-install d'attendre que l'installation
#             soit terminée et la VM rebootée
