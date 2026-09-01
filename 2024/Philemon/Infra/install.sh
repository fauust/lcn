#!/usr/bin/env bash

VM_IP="192.168.122.197"

virt-install \
  --connect=qemu:///system \
  --name=testscript2 \
  --vcpus=3 \
  --ram=2048 \
  --location http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --graphics spice \
  --noautoconsole \
  --network=default,model=virtio \
  --os-type=linux \
  --os-variant=debian12 \
  --disk size=5 \
  --wait -1

# Waiting the VM be ready
echo "Attente que la VM soit accessible en SSH..."
until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "echo 'SSH est prêt'" 2>/dev/null; do
 sleep 5
done

# Connection by pass fingerprint
#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP

# install apache
#virsh snapshot-revert testscript basicInstall
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null apache.sh phil@$VM_IP:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "sudo bash ./apache.sh"
echo "Apache installed"

# install php
#virsh snapshot-revert testscript apacheInstalled
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null php.sh phil@$VM_IP:
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null testProject.php phil@$VM_IP:
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vhostphp.conf phil@$VM_IP:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "sudo bash ./php.sh"
echo "PHP installed"

# install mariadb
#virsh snapshot-revert testscript phpInstall

echo "install mariadb"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null mariadb.sh phil@$VM_IP:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "sudo bash ./mariadb.sh"
echo "mariadb installed"

echo "create tables"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null create_table.sh phil@$VM_IP:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "sudo bash ./create_table.sh"
echo "tables created"

echo "insert data"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null insert_data.sh phil@$VM_IP:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null phil@$VM_IP "sudo bash ./insert_data.sh"
echo "data inserted"
