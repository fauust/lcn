#!/bin/bash

# Default values
VM_NAME="deb"
VCPUS=2
RAM=2048
LOCATION="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/"
DISK_SIZE=50
SERVER="192.168.122.42"
USERNAME="axpoty"
SSH_KEY="/home/axpoty/.ssh/id_ed25519.pub"
PRESEED_CFG_TEMPLATE="preseed.cfg.template"
PRESEED_CFG="preseed.cfg"
POSTINST_SH="postinst.sh"
HOSTNAME="atopy"
DOMAIN="local"
MIRROR_HOSTNAME="deb.debian.org"
MIRROR_DIRECTORY="/debian"
TIMEZONE="Europe/Paris"
LOCALE="en_US"
KEYMAP="fr(latin9)"
NAMESERVERS="9.9.9.9"
NETMASK="255.255.255.0"
GATEWAY="192.168.122.1"
USER_FULLNAME="Axel Poty"
PASSWORD_CRYPT="$6$/QaDAPd5inw5jsmC$7Qb/GwggrunaXEqn7kV/qBGlmnkbiPRam.u4I2srETn5B9eTJvyevLZFzCciginKwCe8aXAJOYkn2nhREiC3p0"

# Parse command-line options
while getopts ":n:c:r:l:d:s:u:k:e:i:h" opt; do
	case ${opt} in
	n) VM_NAME=$OPTARG ;;
	c) VCPUS=$OPTARG ;;
	r) RAM=$OPTARG ;;
	l) LOCATION=$OPTARG ;;
	d) DISK_SIZE=$OPTARG ;;
	s) SERVER=$OPTARG ;;
	u) USERNAME=$OPTARG ;;
	k) SSH_KEY=$OPTARG ;;
	e) PRESEED_CFG_TEMPLATE=$OPTARG ;;
	i) POSTINST_SH=$OPTARG ;;
	h)
		echo "Usage: $0 [-n VM_NAME] [-c VCPUS] [-r RAM] [-l LOCATION] [-d DISK_SIZE] [-s SERVER] [-u USERNAME] [-k SSH_KEY] [-e PRESEED_CFG_TEMPLATE] [-i POSTINST_SH]"
		exit 0
		;;
	\?)
		echo "Invalid option: $OPTARG" 1>&2
		exit 1
		;;
	:)
		echo "Invalid option: $OPTARG requires an argument" 1>&2
		exit 1
		;;
	esac
done

# Values for preseed
IPADDRESS=$SERVER
USER=$USERNAME

# Create the preseed.cfg file from the template
sed -e "s|{{HOSTNAME}}|$HOSTNAME|g" \
	-e "s|{{DOMAIN}}|$DOMAIN|g" \
	-e "s|{{MIRROR_HOSTNAME}}|$MIRROR_HOSTNAME|g" \
	-e "s|{{MIRROR_DIRECTORY}}|$MIRROR_DIRECTORY|g" \
	-e "s|{{TIMEZONE}}|$TIMEZONE|g" \
	-e "s|{{LOCALE}}|$LOCALE|g" \
	-e "s|{{KEYMAP}}|$KEYMAP|g" \
	-e "s|{{NAMESERVERS}}|$NAMESERVERS|g" \
	-e "s|{{IPADDRESS}}|$IPADDRESS|g" \
	-e "s|{{NETMASK}}|$NETMASK|g" \
	-e "s|{{GATEWAY}}|$GATEWAY|g" \
	-e "s|{{USER_FULLNAME}}|$USER_FULLNAME|g" \
	-e "s|{{USERNAME}}|$USERNAME|g" \
	-e "s|{{PASSWORD_CRYPT}}|$PASSWORD_CRYPT|g" \
	"$PRESEED_CFG_TEMPLATE" >"$PRESEED_CFG"

# Verify that the preseed.cfg file was created successfully
if [ ! -f "$PRESEED_CFG" ]; then
	echo "Error: Preseed configuration file '$PRESEED_CFG' was not created."
	exit 1
fi

# Debug: Check the contents of preseed.cfg before continuing
#echo "Contents of $PRESEED_CFG:"
#cat "$PRESEED_CFG"

# Ensure network is set to autostart
sudo virsh net-autostart default

# Install the virtual machine
virt-install \
	--name "$VM_NAME" \
	--vcpus="$VCPUS" \
	--ram="$RAM" \
	--location="$LOCATION" \
	--initrd-inject="$PRESEED_CFG" \
	--initrd-inject="$POSTINST_SH" \
	--initrd-inject="$SSH_KEY" \
	--extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--noautoconsole \
	--wait -1 \
	--console pty,target_type=serial \
	--network default,model=virtio \
	--os-type=linux \
	--os-variant=debian12 \
	--disk=pool=default,size="$DISK_SIZE",format=qcow2,bus=virtio
