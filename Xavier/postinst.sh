#!/usr/bin/env bash

# Takes two arguments : username and public key string

user="$1"
key="$2"

# Copy public key
mkdir -p /home/$user/.ssh
echo $key > /home/$user/.ssh/authorized_keys
# Set rights
chown -R $user:$user /home/$user/.ssh
chmod 600 /home/$user/.ssh/authorized_keys

# Allow user to enter sudo commands with no password
echo "$user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user
chmod 440 /etc/sudoers.d/$user
