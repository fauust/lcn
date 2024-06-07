#!/user/bin/env bash

apt update -y
apt install apache2 -y
systemctl restart apache2
