#!/usr/bin/env bash

SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuheb2yASQoeqPvRcspiK5fPzflzN/NPXKwbZ1NP8it"

mkdir /home/phil/.ssh
echo "$SSH_KEY" >/home/phil/.ssh/authorized_keys
chmod 700 /home/phil/.ssh
chown -R phil:phil /home/phil/.ssh


# configure NOPASSWD
USER="phil ALL=(ALL) NOPASSWD:ALL"
echo "$USER" >/etc/sudoers.d/phil
chmod 440 /etc/sudoers.d/phil
