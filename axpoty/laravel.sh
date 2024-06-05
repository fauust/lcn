#! /bin/bash

# apache2
#apt install -y apache2

# sources for php

# Save existing php package list to packages.txt file
dpkg -l | grep php | tee packages.txt

# Add Ondrej's repo source and signing key along with dependencies
apt install -y apt-transport-https
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update -y

# Install new PHP 8.3 packages
apt install -y php8.3 php8.3-cli php8.3-{sqlite3,bz2,curl,mbstring,intl}

# Install FPM OR Apache module
apt install -y php8.3-fpm
# OR
# apt install libapache2-mod-php8.3

# On Apache: Enable PHP 8.3 FPM
a2enconf php8.3-fpm

# install php and extensions
apt install -y php8.3-fpm php8.3-curl php8.3 php8.3-xml php8.3-dom php8.3-zip
# install git
apt install -y git

# Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Move compose.phar to  /usr/local/bin/composer
mv composer.phar /usr/local/bin/composer

# Create laravel project
su -l -c "composer create-project laravel/laravel vm-app" axpoty

cd /home/axpoty/vm-app || exit

# install laravel libs
su -l -c "composer install" axpoty
su -l -c "php artisan migrate" axpoty
cd ..

# Move app to /var/www
mv vm-app /var/www/vm-app

# Set permissions for www-data
chown -R www-data:www-data /var/www/vm-app

### APACHE2 CONFIG ###

cp vm-app.conf /etc/apache2/sites-available/vm-app.conf

a2ensite vm-app.conf
rm /etc/apache2/sites-available/000-default.conf

systemctl restart apache2
