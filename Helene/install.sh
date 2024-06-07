#!/bin/bash
VM_IP="192.168.122.32"
virt-install \
	--connect=qemu:///system \
	--name debvm \
	--noautoconsole \
	--vcpu=2 \
	--ram=2048 \
	--graphics spice \
  --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
	--disk size=20 \
	--os-variant=debian12 \
	--wait -1 \
	--debug

#Copy scripts
scp -o "StrictHostKeyChecking no" install_apache.sh $VM_IP:
scp -o "StrictHostKeyChecking no" setup.sql $VM_IP:
ssh -o "StrictHostKeyChecking no" $VM_IP "sudo bash ./install_apache.sh"

