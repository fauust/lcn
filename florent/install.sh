#!/usr/bin/env bash
virt-install \
	--console=pty,target_type=serial \
	--disk=pool=default,size=20,format=qcow2,bus=virtio \
	--extra-args="auto console=ttyS0, 115200n8 serial" \
	--graphics=none \
	--initrd-inject=preseed.cfg \
	--location=/home/florent/Téléchargements/debian-12.5.0-amd64-netinst.iso \
	--memory=4096 \
	--name=new-vm \
	--network=default,model=virtio \
	--os-variant=debian12 \
	--vcpus=4