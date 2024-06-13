#!/usr/bin/env bash

### install php

sudo apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm
sudo systemctl reload apache2
cd ../../var/www/html/ || exit
sudo echo "<?php phpinfo(); ?>" | sudo tee index.php
