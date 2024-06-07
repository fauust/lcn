#!/usr/bin/env bash

VM_IP="192.168.122.197"

#virt-install \
#  --connect=qemu:///system \
#  --name=testscript \
#  --vcpus=4 \
#  --ram=2048 \
#  --location=/home/philemon/Téléchargements/debian-12.5.0-amd64-netinst.iso \
#  --initrd-inject=preseed.cfg \
#  --initrd-inject=postinst.sh \
#  --graphics spice \
#  --noautoconsole \
#  --network=default,model=virtio \
#  --os-type=linux \
#  --os-variant=debian12 \
#  --disk size=5 \
#  --wait -1

# Waiting the VM be ready
#echo "Attente que la VM soit accessible en SSH..."
#until ssh "-o StrictHostKeyChecking=no" phil@$VM_IP "echo 'SSH est prêt'" 2>/dev/null; do
# sleep 5
#done

# Connection by pass fingerprint
#ssh -o "StrictHostKeyChecking no" phil@$VM_IP

# install apache
virsh snapshot-revert testscript basicInstall
scp -o "StrictHostKeyChecking=no" apache.sh phil@$VM_IP:.
ssh -o "StrictHostKeyChecking=no" phil@$VM_IP "sudo bash ./apache.sh"

