#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./function_post_install.sh

#make it work ! even dirty : install of laravel demo



#install php for laravel
sudo apt install -y php php-fpm php-mbstring php-xmlrpc php-soap php-gd php-xml php-cli php-zip php-bcmath php-tokenizer php-json php-pear php-mysql zip php-sqlite3
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm

#installing composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"


sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
yes | composer create-project laravel/laravel example-app


#initiate project
cd ./example-app/
composer install
cat > .env<<-EOF

APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:ro0rKTJJJWfp5cwy0ZRI6Zd7aqmv/f0NVxH5cUF3tkY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://localhost

APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US

APP_MAINTENANCE_DRIVER=file
APP_MAINTENANCE_STORE=database

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mariadb
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=test
DB_PASSWORD=test

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
CACHE_PREFIX=

MEMCACHED_HOST=127.0.0.1

REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

VITE_APP_NAME="${APP_NAME}"
EOF

#create the table in mariadb:
cat > myappdb.sql<<-EOF
CREATE DATABASE laravel;
CREATE USER 'test'@'localhost' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'localhost';
FLUSH PRIVILEGES;
EOF

sudo mariadb  < myappdb.sql
php artisan migrate --force
# shellcheck disable=SC2103
cd ..

#setting the directory with right rights dans /var/www
sudo mv ./example-app /var/www/
sudo chown -R www-data:www-data /var/www/example-app


## configure apache

cat > my-app.conf<<-EOF
<VirtualHost *:80>
        ServerName my-app.local

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/example-app/public
        <Directory /var/www/example-app/public>
          require all granted
          Options Indexes FollowSymLinks
          AllowOverride All
        </Directory>

        LogLevel info

        ErrorLog /var/log/apache2/my-app.error.log
        CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

#settings of apache for hte laravel project

sudo cp my-app.conf /etc/apache2/sites-available/my-app.conf
sudo rm /etc/apache2/sites-available/000-default.conf
sudo a2ensite my-app.conf
sudo systemctl reload apache2.service

#
#edit hosts file
#echo "127.0.0.1    www.my-app.local"| sudo tee -a /etc/hosts/

#test
