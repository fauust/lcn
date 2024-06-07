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
php artisan migrate --force
# shellcheck disable=SC2103
cd ..




#isetting the directory with right rights dans /var/www
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
