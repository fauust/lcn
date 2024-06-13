#!/bin/bash
VM_IP="192.168.122.32"
USER="helenevm"
#virt-install \
#	--connect=qemu:///system \
#	--name debvm \
#	--noautoconsole \
#	--vcpu=2 \
#	--ram=2048 \
#	--graphics spice \
#  --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
#	--initrd-inject=preseed.cfg \
#	--initrd-inject=postinst.sh \
#	--disk size=20 \
#	--os-variant=debian12 \
#	--wait -1 \
#	--debug

Copy scripts
scp -o "StrictHostKeyChecking no" install_apache.sh $USER@$VM_IP:
ssh -o "StrictHostKeyChecking no" $USER@$VM_IP "sudo bash ./install_apache.sh"
scp -o "StrictHostKeyChecking no" /var/www/infraVMserver/ $USER@$VM_IP:/var/www/blog.local