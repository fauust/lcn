#!/usr/bin/env bash
apt update -y
apt upgrade -y
apt install -y mariadb-server mariadb-client
mysql -u root << EOF
CREATE DATABASE laravel_db;
CREATE USER 'florent'@'localhost' IDENTIFIED BY '0000';
GRANT ALL ON laravel_db.* TO 'florent'@'localhost';
FLUSH PRIVILEGES;
EOF