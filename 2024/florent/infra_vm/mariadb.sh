#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
source /tmp/config.sh

apt update -y
apt upgrade -y
apt install -y mariadb-server mariadb-client
mariadb << EOF
CREATE DATABASE IF NOT EXISTS "$DB_NAME";
CREATE USER IF NOT EXISTS "$USER"@'localhost' IDENTIFIED BY "$DB_PWD";
GRANT ALL ON "$DB_NAME".* TO "$USER"@'localhost';
FLUSH PRIVILEGES;
EOF