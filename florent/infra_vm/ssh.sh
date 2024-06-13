#!/usr/bin/env bash

mkdir -p "/home/$USER/.ssh"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8SghDe0RGdeSbuXhaFeNIlopTLH089if4AFc69ewdI $USER@$USER-desktop" > "/home/$USER/.ssh/authorized_keys"
chmod 600 "/home/$USER/.ssh/authorized_keys"
chown -R "$USER:$USER /home/$USER/.ssh"