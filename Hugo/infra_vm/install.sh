#! /usr/bin/bash

virt-install \
    --connect=qemu:///system \
    --name deb \
    --vcpus=2 \
    --ram=2048 \
    --location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
    --initrd-inject=preseed.cfg \
    --initrd-inject=postinst.sh \
    --wait -1 \
    --initrd-inject=laravel.sh \
    --initrd-inject=apache.sh \
    --initrd-inject=mariadb.sh \
    --extra-args="auto console=ttyS0,115200n8 serial" \
    --graphics none \
    --console pty,target_type=serial \
    --network default,model=virtio \
    --os-type=linux \
    --noautoconsole \
    --os-variant=debian12

SERVER="192.168.122.42"
PORT=22
USER="hugouser"

### Loop until the port is available ###
while ! nc -z $SERVER $PORT; do
    echo "Waiting for port $PORT on $SERVER to be available..."
    sleep 5
    ### Wait for 5 seconds before checking again ###
done
echo "Port $PORT on $SERVER is now available!"

### Copy the scripts to the VM ###
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null laravel.sh apache.sh mariadb.sh $USER@$SERVER:/home/$USER/

### Run the laravel.sh script on the VM ###
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $USER@$SERVER "chmod +x /home/$USER/*.sh && sudo /home/$USER/laravel.sh"
