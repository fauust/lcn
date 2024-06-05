#!/usr/bin/bash

# Let's Go !! #################################################


virt-install \
	--connect=qemu:///system \
	--name "$1" \
	--vcpus=4 \
	--ram=8192 \
	--location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
	--extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--noautoconsole \
	--console pty,target_type=serial \
	--extra-args="ks=file:/preseed.cfg" \
	--network default,model=virtio \
	--os-variant=debian12 \
	--disk=pool=default,size=50,format=qcow2,bus=virtio\
	--wait=-1
