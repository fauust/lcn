#!/bin/bash

### Variables ###
DB_ROOT_PASS=$1
DB_USER=$2
DB_PASS=$3
PROJECT_NAME=$4

### Install MariaDB ###
sudo apt-get install -y mariadb-server
sudo mariadb-secure-installation <<EOF
n
n
n
Y
Y
Y
Y
EOF

### Create Database and User ###
<<EOF
CREATE DATABASE $PROJECT_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $PROJECT_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF
