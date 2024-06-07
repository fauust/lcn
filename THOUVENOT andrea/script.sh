#!/usr/bin/env bash

#ssh-keygen -f "/home/thouvenot/.ssh/known_hosts" -R "192.168.122.85"
#
#virt-install\
#  --connect=qemu:///system \
#  --name=VM\
#  --memory=4096\
#  --vcpus=4\
#  --initrd-inject=preseed.cfg\
#  --initrd-inject=commandevm.sh\
#  --initrd-inject=installapache.sh\
#  --noautoconsole\
#	--location=/home/thouvenot/Téléchargements/debian-12.5.0-amd64-netinst.iso\
#	--graphics=spice\
#	--noautoconsole \
#  --autostart \
#	--wait


sudo virsh snapshot-revert VM snapshotVM
sleep 2
scp -o "StrictHostKeyChecking no" install_mariadb.sh andrea@192.168.122.85:
ssh -o "StrictHostKeyChecking no" andrea@192.168.122.85 "sudo bash ./install_mariadb.sh"
scp -o "StrictHostKeyChecking no" installapache.sh andrea@192.168.122.85:
ssh -o "StrictHostKeyChecking no" andrea@192.168.122.85 "sudo bash ./installapache.sh"
scp -o "StrictHostKeyChecking no" install_php.sh andrea@192.168.122.85:
ssh -o "StrictHostKeyChecking no" andrea@192.168.122.85 "sudo bash ./install_php.sh"

