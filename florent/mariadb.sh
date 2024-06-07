#!/usr/bin/env bash

USER="florent"
PWD="0000"
DB_NAME="db_vm"

apt update -y
apt upgrade -y
apt install -y mariadb-server mariadb-client
mariadb -u root << EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PWD';
GRANT ALL ON $DB_NAME.* TO '$USER'@'localhost';
FLUSH PRIVILEGES;
EOF