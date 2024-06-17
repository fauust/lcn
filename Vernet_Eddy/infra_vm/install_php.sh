#!/usr/bin/env bash

### install php

sudo apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm
sudo systemctl reload apache2
sudo cp ./PDO.php /var/www/html/index.php