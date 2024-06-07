#!/bin/bash

sudo apt update
sudo apt -y install composer
composer create-project --prefer-dist laravel/laravel /var/www/monprojet \
composer install -d /var/www/monprojet

sudo systemctl reload apache2.service
