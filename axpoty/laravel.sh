#!/bin/bash

#Enable php conf for Apache2
sudo a2enconf php8.3-fpm
sudo a2enmod proxy_fcgi setenvif
sudo systemctl reload apache2

# Create laravel project
composer create-project laravel/laravel vm-app

cd /home/axpoty/vm-app || exit

# Install laravel dependencies
composer install
php artisan migrate
cd ..

# Move app to /var/www
sudo mv vm-app /var/www/vm-app

# Set permissions for www-data
sudo chown -R www-data:www-data /var/www/vm-app
