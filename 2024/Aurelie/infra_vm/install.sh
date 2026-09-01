#!/usr/bin/env bash
#virt-install     --connect=qemu:///system \
#                 --name="vmtest" \
#                 --ram=2048 \
#                 --vcpus=2 \
#                 --disk size=20,path="/var/lib/libvirt/images/vmtest.qcow2,bus=virtio,cache=none" \
#                 --initrd-inject=preseed.cfg \
#                 --initrd-inject=postinst.sh \
#                 --noautoconsole \
#                 --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
#                 --graphics spice \
#                 --noautoconsole \
#                 --autostart \
#                 --wait

# Définir l'adresse IP de la machine virtuelle
VM_IP=aurelie@192.168.122.51

sudo virsh-revert vmtest database

### script apache ####
#scp -o "StrictHostKeyChecking no" apache.sh $VM_IP:
#ssh -o "StrictHostKeyChecking no" $VM_IP "sudo bash ./apache.sh"

### script php ###
#scp -o "StrictHostKeyChecking no" php.sh $VM_IP:
#ssh -o "StrictHostKeyChecking no" $VM_IP "sudo bash ./php.sh"

## script mariadb ###
#scp -o "StrictHostKeyChecking no" mariadb.sh $VM_IP:
#ssh -o "StrictHostKeyChecking no" $VM_IP "sudo bash ./mariadb.sh"

#### script setup database ###
#scp -o "StrictHostKeyChecking no" create_contact_table.sql $VM_IP:
#scp -o "StrictHostKeyChecking no" setup_database.sh $VM_IP:
#ssh -o "StrictHostKeyChecking no" $VM_IP "bash ./setup_database.sh"

### Copy file index.php on VM ###
scp -o "StrictHostKeyChecking no" index.php aurelie@192.168.122.51:/home/aurelie/index.php
ssh -o "StrictHostKeyChecking no" aurelie@192.168.122.51 "sudo mv /home/aurelie/index.php /var/www/html/index.php"


### restart apache ###
ssh -o "StrictHostKeyChecking no" $VM_IP "sudo systemctl restart apache2"
