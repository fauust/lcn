#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
source config.sh
# shellcheck disable=SC1090,SC1091
source preseed.sh

# A RETIRER APRES TEST !!!
# ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R "$IP"

# virt-install \
# 	--connect=qemu:///system \
# 	--console=pty,target_type=serial \
# 	--disk=pool=default,size=20,format=qcow2,bus=virtio \
# 	--extra-args='auto console=ttyS0, 115200n8 serial' \
# 	--graphics=none \
# 	--initrd-inject=preseed.cfg \
# 	--initrd-inject=ssh.sh \
# 	--initrd-inject=sudoers.sh \
# 	--location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
# 	--memory=4096 \
# 	--name="$VM_NAME" \
# 	--network=default,model=virtio \
# 	--os-variant=debian12 \
# 	--vcpus=4 \
# 	--noautoconsole \
# 	--wait

# while ! $NC; do
#     echo 'VM starting...'
#     sleep 1
# done

# scp -o 'StrictHostKeyChecking no' config.sh "$USER@$IP":/tmp

# scp -o 'StrictHostKeyChecking no' php.sh "$USER@$IP":/tmp
# ssh -o 'StrictHostKeyChecking no' "$USER@$IP" 'sudo bash /tmp/php.sh'
# scp -o 'StrictHostKeyChecking no' apache.sh "$USER@$IP":/tmp
# ssh -o 'StrictHostKeyChecking no' "$USER@$IP" 'sudo bash /tmp/apache.sh'
# scp -o 'StrictHostKeyChecking no' mariadb.sh "$USER@$IP":/tmp
# ssh -o 'StrictHostKeyChecking no' "$USER@$IP" 'sudo bash /tmp/mariadb.sh'
# scp -o 'StrictHostKeyChecking no' req.sh "$USER@$IP":/tmp
# ssh -o 'StrictHostKeyChecking no' "$USER@$IP" 'sudo bash /tmp/req.sh'

# virsh reset "$VM_NAME"