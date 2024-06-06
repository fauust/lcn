#!/usr/bin/env bash
#virt-install     --connect=qemu:///system \
#                 --name="vmtest" \
#                 --ram=2048 \
#                 --vcpus=2 \
#                 --disk size=20,path="/var/lib/libvirt/images/vmtest.qcow2,bus=virtio,cache=none" \
#                 --initrd-inject=preseed.cfg \
#                 --initrd-inject=postinst.sh \
#                 --initrd-inject=apache.sh \
#                 --initrd-inject=php.sh \
#                 --noautoconsole \
#                 --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
#                 --graphics spice \
#                 --noautoconsole \
#                 --autostart \
#                 --wait

# Définir l'adresse IP de la machine virtuelle
VM_IP=aurelie@192.168.122.51

sudo virsh-revert vmtest apache
scp -o "StrictHostKeyChecking no" php.sh $VM_IP:
ssh -o "StrictHostKeyChecking no" $VM_IP "sudo bash ./php.sh"