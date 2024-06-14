#!/usr/bin/env bash

MBD_PASSWORD="campus"

### install mariaDB ###
apt-get install -y mariadb-server

### start mariadb ###
service mariadb start
systemctl enable mariadb

### Create user database ###
mysql << EOF
CREATE USER 'aurelie'@'localhost' IDENTIFIED BY '${MBD_PASSWORD}';
GRANT ALL PRIVILEGES ON contacts_db.* TO 'aurelie'@'localhost';
FLUSH PRIVILEGES;
EOF