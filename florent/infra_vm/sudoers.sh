#!/usr/bin/env bash

# https://askubuntu.com/questions/147241/execute-sudo-without-password
echo "$USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USER"
chmod 440 "/etc/sudoers.d/$USER"