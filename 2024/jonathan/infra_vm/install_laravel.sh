#!/usr/bin/env bash

#install php
sudo apt update
sudo apt install -y php php-fpm php-xml php-dom curl git zip unzip

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
sudo echo "127.0.0.1	vm-app.local" | sudo tee -a /etc/hosts
sudo mv /home/jon/vm_app.local.conf /etc/apache2/sites-available/
sudo chown jon:jon /etc/apache2/sites-available/vm_app.local.conf
composer create-project laravel/laravel /home/jon/vm_app
cd /home/jon/vm_app || return
composer install
sudo mv /home/jon/vm_app/ /var/www/
sudo chown -R www-data:www-data /var/www/vm_app/
sudo a2ensite vm_app.local.conf
sudo systemctl reload apache2.service
