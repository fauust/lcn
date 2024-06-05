#!/usr/bin/env bash
virt-install \
	--connect=qemu:///system \
	--console=pty,target_type=serial \
	--disk=pool=default,size=20,format=qcow2,bus=virtio \
	--extra-args="auto console=ttyS0, 115200n8 serial" \
	--graphics=none \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
	--location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
	--memory=4096 \
	--name=vm-deb \
	--network=default,model=virtio \
	--os-variant=debian12 \
	--vcpus=4 \
	--noautoconsole \
	--wait