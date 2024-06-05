#!/usr/bin/env bash

#Config SSH
mkdir "/home/helenevm/.ssh"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQNoc/qgVg4reg7juqJGOS806pU8m2EB+5sglng592o helene.finot@le-campus-numerique.fr" > /home/helenevm/.ssh/authorized_keys
chown -R helenevm:helenevm /home/helenevm/.ssh

#Config No password
echo "helenevm ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers
