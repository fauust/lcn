#!/usr/bin/env bash

### Update and Upgrade ###
apt update && apt upgrade -y


### Installation Apache ###
apt install -y apache2 

### Installation Php ###
apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip

### link Apache and Php ###
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
systemctl reload apache2

### Add conf for VirtualHost ###
cd /etc/apache2/sites-available/ || exit

#echo "<VirtualHost *:80>
#    DocumentRoot /var/www/html/my-app/public/
#    ServerName myapp.vm
#    ErrorLog ${APACHE_LOG_DIR}/error_back.log
#    CustomLog ${APACHE_LOG_DIR}/access_back.log combined
#    <Directory /var/www/html/my-app/public>
#        Options Indexes FollowSymLinks
#        AllowOverride All
#        Require all granted
#    </Directory>
#</VirtualHost>
#" > myapp.conf

### Delete default conf ###
#rm  /etc/apache2/sites-available/000-default.conf

### link between sites-available and enable ###
cd /etc/apache2/sites-enabled/ || exit
ln -s /etc/apache2/sites-available/myapp.conf .

### reload service ###
systemctl restart php8.2-fpm apache2

