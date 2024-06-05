#!/usr/bin/env bash

# command to do after install :
#####################################################################################################
#configure sudo without password

DEFAULTVALUE=jamil
NAME="${1:-$DEFAULTVALUE}"
echo "$NAME" | (EDITOR="tee -a" visudo)

#######################################################################################################
#configure ssh
echo toto >> /"$NAME"/test.txt
mkdir -p /home/"$NAME"/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmxfkx2ZGwhmLr+41N9QX1VPKNsziU/9ux+GJrj83lT jamil.abidi@le-campus-numerique.fr" >> /home/"$NAME"/.ssh/authorized_keys
chmod -R go= /home/"$NAME"/.ssh
chown -R "$NAME":"$NAME" /home/"$NAME"/.ssh
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/test.conf
systemctl restart ssh
