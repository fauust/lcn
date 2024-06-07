#!/usr/bin/env bash

USER="florent"
IP="192.168.122.66"
NC="nc -vz $IP 22"

# ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R $IP

# virt-install \
# 	--connect=qemu:///system \
# 	--console=pty,target_type=serial \
# 	--disk=pool=default,size=20,format=qcow2,bus=virtio \
# 	--extra-args="auto console=ttyS0, 115200n8 serial" \
# 	--graphics=none \
# 	--initrd-inject=preseed.cfg \
# 	--initrd-inject=ssh.sh \
# 	--initrd-inject=sudoers.sh \
# 	--location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
# 	--memory=4096 \
# 	--name=vm-deb \
# 	--network=default,model=virtio \
# 	--os-variant=debian12 \
# 	--vcpus=4 \
# 	--noautoconsole \
# 	--wait

while [ "$NC" != 0 ]; do
    echo "VM starting..."
    sleep 1
done

scp -o "StrictHostKeyChecking no" php.sh $USER@$IP:
ssh -o "StrictHostKeyChecking no" $USER@$IP "sudo bash ./php.sh"
scp -o "StrictHostKeyChecking no" apache.sh $USER@$IP:
ssh -o "StrictHostKeyChecking no" $USER@$IP "sudo bash ./apache.sh"
scp -o "StrictHostKeyChecking no" mariadb.sh $USER@$IP:
ssh -o "StrictHostKeyChecking no" $USER@$IP "sudo bash ./mariadb.sh"