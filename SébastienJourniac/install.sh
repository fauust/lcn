#!/usr/bin/env bash
ssh-keygen -f "/home/journiac/.ssh/known_hosts" -R "192.168.122.51"

virt-install --connect=qemu:///system \
 --name="vmtest" \
 --ram=2048 \
 --vcpus=2 \
 --disk size=20,path="/var/lib/libvirt/images/vmtest.qcow2,bus=virtio,cache=none" \
 --initrd-inject=preseed.cfg \
 --initrd-inject=commandevm.sh \
 --initrd-inject=installapache.sh \
 --initrd-inject=installphp.sh \
 --noautoconsole \
 --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
 --graphics spice \
 --noautoconsole \
 --autostart \
 --wait
