#!/usr/bin/env bash

mkdir -p /home/florent/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8SghDe0RGdeSbuXhaFeNIlopTLH089if4AFc69ewdI florent@florent-desktop" > /home/florent/.ssh/authorized_keys
chmod 600 /home/florent/.ssh/authorized_keys
chown -R florent:florent /home/florent/.ssh