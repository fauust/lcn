#!/usr/bin/env bash

echo "jon ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

mkdir /home/jon/.ssh
cat /root/id_ed25519.pub >> /home/jon/.ssh/authorized_keys
rm /root/id_ed25519.pub
chown -R jon:jon /home/jon/.ssh
chmod 700 /home/jon/.ssh
chmod 600 /home/jon/.ssh/authorized_keys

