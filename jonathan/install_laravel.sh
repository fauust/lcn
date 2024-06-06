#!/usr/bin/env bash

#install php
sudo apt update
sudo apt install -y php-fpm curl

sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php-fpm
sudo systemctl restart apache2.service

#install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

#install npm
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && sudo apt-get install -y nodejs

#create new project
#composer create-project laravel/laravel /var/www/vm_app
#a2ensite vm_app.conf
