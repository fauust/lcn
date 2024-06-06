#!/usr/bin/env bash

#Update & Upgrade System
sudo apt update && sudo apt upgrade -y

#Install package
sudo apt install apache2 -y
sudo apt install mariadb-server -y
sudo systemctl enable mariadb