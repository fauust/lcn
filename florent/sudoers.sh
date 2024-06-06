#!/usr/bin/env bash
# https://askubuntu.com/questions/147241/execute-sudo-without-password
echo 'florent ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/florent
chmod 440 /etc/sudoers.d/florent