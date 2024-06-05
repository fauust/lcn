#!/usr/bin/env bash



virt-install --name=vm-try01 \
	--vcpus=2 \
	--noautoconsole \
	--memory=2048 \
	--location /home/jon/Downloads/debian-12.5.0-amd64-netinst.iso \
	--disk size=10 \
	--os-variant=debian12 \
	--wait -1
