#!/usr/bin/env bash

mkdir -p /home/thouvenot/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2nNlUiutuaTMmRxKb93IOLmA12cCXXTx+5Kho52I68 andrea.thouvenot@le-campus-numerique.fr" > /home/thouvenot/.ssh/authorized_keys
chmod 600 /home/thouvenot/.ssh/authorized_keys
chown -R thouvenot:thouvenot /home/thouvenot/.ssh

echo 'thouvenot ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/thouvenot
chmod 440 /etc/sudoers.d/thouvenot