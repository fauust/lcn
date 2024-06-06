#! /bin/bash
sudo virsh net-autostart default
virt-install \
	--name deb \
	--vcpus=2 \
	--ram=2048 \
	--location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
	--initrd-inject=preseed.cfg \
	--initrd-inject=postinst.sh \
	--initrd-inject=/home/axpoty/.ssh/id_ed25519.pub \
	--extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--noautoconsole \
	--wait -1 \
	--console pty,target_type=serial \
	--network default,model=virtio \
	--os-type=linux \
	--os-variant=debian12 \
	--disk=pool=default,size=50,format=qcow2,bus=virtio
