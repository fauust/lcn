#!/usr/bin/env bash

# This script will be copied to /tmp/ and executed in the target system
# Configure sudo to allow 'aurelie' to execute commands without password
echo 'aurelie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/aurelie
chmod 440 /etc/sudoers.d/aurelie

# Setup SSH key authentication
mkdir -p /home/aurelie/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2RkWuHPNES1WInN8Ln6jg1L9SMGZscX/oAP5yRCCBg aurelie.vauquelin@le-campus-numerique.fr' > /home/aurelie/.ssh/authorized_keys
chmod 700 /home/aurelie/.ssh
chmod 600 /home/aurelie/.ssh/authorized_keys
chown -R aurelie:aurelie /home/aurelie/.ssh
