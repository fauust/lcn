#!/usr/bin/env bash

virt-install --connect=qemu:///system \
  --name=vm_2 \
  --vcpus=2 \
  --memory=2048 \
  --location=http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/ \
  --disk size=5 \
  --noautoconsole \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --autostart \
  --wait -1


while ! nc -z 192.168.122.42 22; do
  sleep 1 # wait for 1/10 of the second before check again
done


  # install apache === Pour reprendre à partir d'un snapshot,tout commenter au dessus d'ici + changer le install_apache.sh par le fichier voulu (spoil, c'est install.sh)
scp -o "StrictHostKeyChecking no" install_apache.sh 192.168.122.42:
ssh -o "StrictHostKeyChecking no" 192.168.122.42 "sudo bash ./install_apache.sh"

scp -o "StrictHostKeyChecking no" install_php.sh 192.168.122.42:
ssh -o "StrictHostKeyChecking no" 192.168.122.42 "sudo bash ./install_apache.sh"