#!/usr/bin/bash

# Let's Go !! #################################################

virt-install \
	--connect=qemu:///system \
	--name "$1" \
	--vcpus=4 \
	--ram=8192 \
	--location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
        --extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--noautoconsole \
	--console pty,target_type=serial \
	--network default,model=virtio \
	--os-variant=debian12 \
	--disk=pool=default,size=50,format=qcow2,bus=virtio\
	--wait=-1

SERVER="192.168.122.42"
PORT=22

# Loop until the port is available
while ! nc -z $SERVER $PORT; do
	echo "Waiting for port $PORT on $SERVER to be available..."
	sleep 5 # Wait for 5 seconds before checking again
done

echo "Port $PORT on $SERVER is now available!"

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null apache.sh laravel.sh vm.debian:/home/dumasg/

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vm.debian chmod +x /home/dumasg/apache.sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vm.debian chmod +x /home/dumasg/laravel.sh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vm.debian sudo ./apache.sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vm.debian sudo ./laravel.sh
