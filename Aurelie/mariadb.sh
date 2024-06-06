#!/usr/bin/env bash

### install mariaDB ###
sudo apt-get install -y mariadb-server

### start mariadb ###
service mariadb start
systemctl enable mariadb