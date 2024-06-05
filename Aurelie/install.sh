#!/usr/bin/env bash
virt-install     --connect=qemu:///system \
                 --name="vmtest" \
                 --ram=2048 \
                 --vcpus=2 \
                 --disk size=20,path="/var/lib/libvirt/images/vmtest.qcow2,bus=virtio,cache=none" \
                 --initrd-inject=preseed.cfg \
                 --noautoconsole \
                 --location /var/lib/libvirt/images/debian-12.5.0-amd64-netinst.iso\
                 --graphics spice \
                 --noautoconsole \
                 --autostart \
                 --wait
