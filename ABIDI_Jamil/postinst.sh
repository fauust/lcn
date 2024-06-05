#!/usr/bin/env bash

# command to do after install :
#####################################################################################################
#configure sudo without password

DEFAULTVALUE=jamil
NAME="${1:-$DEFAULTVALUE}"
echo "$1" | (EDITOR="tee -a" visudo)

#######################################################################################################
#configure ssh
echo toto >> /"$1"/test.txt
mkdir -p /home/"$1"/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmxfkx2ZGwhmLr+41N9QX1VPKNsziU/9ux+GJrj83lT jamil.abidi@le-campus-numerique.fr" >> /home/"$1"/.ssh/authorized_keys
chmod -R go= /home/"$1"/.ssh
chown -R "$1":"$1" /home/"$1"/.ssh
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/test.conf
systemctl restart ssh
