#! /bin/bash
sudo virsh net-autostart default
virt-install \
	--name deb \
	--vcpus=2 \
	--ram=2048 \
	--location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
	--initrd-inject=preseed.cfg \
	--initrd-inject=laravel.sh \
	--initrd-inject=vm-app.conf \
	--extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--noautoconsole \
	--wait -1 \
	--console pty,target_type=serial \
	--extra-args="ks=file:/preseed.cfg" \
	--network default,model=virtio \
	--os-type=linux \
	--os-variant=debian12 \
	--disk=pool=default,size=50,format=qcow2,bus=virtio \
	--debug
#scp laravel.sh axpoty@192.168.122.42:/home/axpoty/
#scp vm-app.conf axpoty@192.168.122.42:/home/axpoty/
#ssh axpoty@192.168.122.42
#chmod +x /home/axpoty/laravel.sh
