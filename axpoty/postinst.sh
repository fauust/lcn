#! /bin/bash
#ssh-keygen -f "/home/axpoty/.ssh/known_hosts" -R "192.168.122.42"
mkdir /home/axpoty/.ssh
cat /root/id_ed25519.pub >>/home/axpoty/.ssh/authorized_keys
echo "axpoty ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
rm /root/id_ed25519.pub
