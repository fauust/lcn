#!/usr/bin/env bash

apt update -y && apt upgrade -y
apt-get install apt-transport-https gnupg2 ca-certificates -y
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
cd /var/www/html || exit
composer create-project --prefer-dist laravel/laravel laravel
chown -R www-data:www-data /var/www/html/laravel
chmod -R 775 /var/www/html/laravel
CONF_FILE="/etc/apache2/sites-available/laravel.conf"
CONF_CONTENT="<VirtualHost *:80>
    ServerName laravel2.example.com

    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews
    AllowOverride None
    Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>"
echo "$CONF_CONTENT" > "$CONF_FILE"
a2enmod rewrite
a2ensite laravel.conf
systemctl reload apache2