#!/usr/bin/env bash

### Add certificates ###
apt reinstall ca-certificates -y
update-ca-certificates

### Installation Composer ###
curl -sS https://getcomposer.org/installer -o composer-setup.php
curl -sS https://composer.github.io/installer.sig

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

### Create project Laravel ###
cd /var/www/html/ || exit
yes | composer create-project laravel/laravel my-app

### Add conf for Laravel app ###
cd /etc/apache2/sites-available/ || exit

echo "<VirtualHost *:80>
    DocumentRoot /var/www/html/my-app/public/
    ServerName myapp.vm
    ErrorLog ${APACHE_LOG_DIR}/error_back.log
    CustomLog ${APACHE_LOG_DIR}/access_back.log combined
    <Directory /var/www/html/my-app/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
" > myapp.conf

### Delete conf default for apache 2 ###
rm  /etc/apache2/sites-available/000-default.conf

### Create symbolic link between sites-available and site-enable ###
cd /etc/apache2/sites-enabled/ || exit
ln -s /etc/apache2/sites-available/myapp.conf .

### Modification user permission ###
chown -R www-data:www-data /var/www/html/my-app/

### Restart PHP ###
systemctl restart php8.2-fpm apache2

### Migration DB ####
cd /var/www/html/my-app/ || exit
php artisan migrate