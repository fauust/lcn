#!/usr/bin/env bash

### Update and Upgrade ###
apt update && apt upgrade -y

### Installation Apache ###
apt install -y apache2

### Installation Php ###
apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip

### link Apache and Php ###
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
systemctl reload apache2

### reload service ###
systemctl restart php8.2-fpm apache2

