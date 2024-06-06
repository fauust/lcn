#!/usr/bin/env bash
mkdir -p /home/grough/.ssh
echo "SHA256:iA8MwsVTDcujzpsfBBIeWLDDWUDqEGyK5zQiKrxaemk journiac@pc-de-sebastien" > /home/grough/.ssh/authorized_keys
chmod 600 /home/grough/.ssh/authorized_keys
chown -R grough:grough /home/grough/.ssh
echo 'grough ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/grough
chmod 440 /etc/sudoers.d/grough
