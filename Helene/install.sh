#!/bin/bash

virt-install \
	--connect=qemu:///system \
	--name debvm \
	--noautoconsole \
	--vcpu=2 \
	--ram=2048 \
	--graphics spice \
	--location=/var/lib/libvirt/images/debian-12.5.0-amd64-netinst.iso \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
	--disk size=20 \
	--os-variant=debian12 \
	--wait -1 \
	--debug






