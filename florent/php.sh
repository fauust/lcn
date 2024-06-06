#!/usr/bin/env bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y php-fpm php-common php-curl php-gd php-cli php-mysql php-mbstring php-dom php-xdebug
sudo systemctl status php8.2-fpm