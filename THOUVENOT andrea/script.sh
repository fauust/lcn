#!/usr/bin/env bash

virt-install\
	--graphics=none\
	--initrd-inject=preseed.cfg\
	--initrd-inject=commandevm.sh\
	--location=/home/thouvenot/Téléchargements/debian-12.5.0-amd64-netinst.iso\
	--memory=4096\
	--name=VM\
	--network=default,model=virtio\
	--os-variant=debian12\
	--vcpus=4\
	--wait

