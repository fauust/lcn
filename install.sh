#!/usr/bin/env bash

virt-install --connect=qemu:///system \
--name=vm_2 \
--vcpus=2 \
--memory=2048 \
--location=/tmp/debian-12.5.0-amd64-netinst.iso \
--disk size=5 \
--noautoconsole \
--initrd-inject=preseed.cfg