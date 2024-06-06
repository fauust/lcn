#!/usr/bin/env bash

mkdir -p /home/florent/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATZkKU4NbhuJZMZ9WjVkhGms5qtHNNs9hZNXprPKtFI florent@florent-desktop" > /home/florent/.ssh/authorized_keys
chmod 600 /home/florent/.ssh/authorized_keys
chown -R florent:florent /home/florent/.ssh

# https://askubuntu.com/questions/147241/execute-sudo-without-password
echo 'florent ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/florent

chmod 440 /etc/sudoers.d/florent