#!/usr/bin/env bash
apt update && apt upgrade -y
apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip mariadb-server apache2


a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
systemctl reload apache2
cd ~ || exit

apt reinstall ca-certificates -y
update-ca-certificates

curl -sS https://getcomposer.org/installer -o composer-setup.php
#HASH=$(curl -sS https://composer.github.io/installer.sig)

curl -sS https://composer.github.io/installer.sig


php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

cd /var/www/html/ || exit

yes | composer create-project laravel/laravel my-app

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

rm  /etc/apache2/sites-available/000-default.conf

cd /etc/apache2/sites-enabled/ || exit

ln -s /etc/apache2/sites-available/myapp.conf .

chown -R www-data:www-data /var/www/html/my-app/

systemctl restart php8.2-fpm apache2

cd /var/www/html/my-app/ || exit
php artisan migrate
