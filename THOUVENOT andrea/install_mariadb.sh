#!/usr/bin/env bash

apt update
apt install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
