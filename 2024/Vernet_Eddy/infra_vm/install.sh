#!/usr/bin/env bash

virt-install --connect=qemu:///system \
  --name=vm_2 \
  --vcpus=2 \
  --memory=2048 \
  --location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
  --disk size=5 \
  --noautoconsole \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --autostart \
  --wait -1


while ! nc -z 192.168.122.42 22; do
  sleep 5 # wait for 1/10 of the second before check again
done


scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" install_apache.sh eddy@192.168.122.42:.
scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" install_php.sh eddy@192.168.122.42:.
scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" install_mariaDB.sh eddy@192.168.122.42:.
scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" PDO.php eddy@192.168.122.42:.


ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 chmod +x /home/eddy/install_apache.sh
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 chmod +x /home/eddy/install_php.sh
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 chmod +x /home/eddy/install_mariaDB.sh



ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 "sudo bash ./install_apache.sh"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 "sudo bash ./install_php.sh"
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile=/dev/null" eddy@192.168.122.42 "sudo bash ./install_mariaDB.sh"