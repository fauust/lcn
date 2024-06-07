#!/usr/bin/env bash

apt update
apt install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation <<EOF

y
mariadbpwd
mariadbpwd
y
y
y
y
EOF
