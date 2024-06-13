#!/bin/bash

### Configure sudoers to allow nopasswd for the user hugouser ###
echo "hugouser ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/hugouser

### Add SSH public key for the user hugouser ###
mkdir -p /home/hugouser/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3BGIb4Iyccca74hlTJ6ADHL56K+5kpXLY4cv66wM05 hugo.chaloyard@le-campus-numerique.fr" | tee /home/hugouser/.ssh/authorized_keys
chown -R hugouser:hugouser /home/hugouser/.ssh
chmod 600 /home/hugouser/.ssh/authorized_keys
