#!/usr/bin/env bash

# Update package list and install necessary dependencies
sudo apt update
sudo apt install git libxml2-dev libpam0g-dev libudisks2-dev libglib2.0-dev gir1.2-udisks-2.0 python3 python3-gi
sudo apt install build-essential autoconf libtool libusb-1.0-0-dev ca-certificates unzip pkg-config libdbus-1-dev

git clone https://github.com/mcdope/pam_usb.git
cd pam_usb/ || exit
make
sudo make install

# Check if pamusb-conf command exists
if ! command -v pamusb-conf &>/dev/null; then
    echo "pamusb-conf command not found. Please make sure pam-usb is installed correctly."
    exit 1
fi

# Identify the USB device name (uncomment and run one of the following commands if needed)
# lsblk
# blkid
# dmesg | grep -i usb

# Replace myusb with the actual USB device name
# Replace myuser with your username
sudo pamusb-conf --add-device myusb
sudo pamusb-conf --add-user augustin
sudo pamusb-conf --link-user augustin myusb

# Modify the PAM configuration
sudo sh -c 'echo "auth sufficient pam_usb.so" > /tmp/temporaryFile'
sudo sh -c 'cat /etc/pam.d/common-auth >> /tmp/temporaryFile'
sudo mv /tmp/temporaryFile /etc/pam.d/common-auth