#!/bin/bash

### Variables ###
DB_USER=$1
PROJECT_NAME=$2

### Install Apache ###
sudo apt update -y
sudo apt install -y apache2
sudo usermod -aG www-data $DB_USER

### Install PHP and enable necessary Apache modules and PHP-FPM ###
sudo apt install -y php8.3-fpm
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.3-fpm
sudo systemctl reload apache2

### Configure Apache virtual host ###
sudo tee /etc/apache2/sites-available/$PROJECT_NAME.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin $DB_USER@localhost
    ServerName $PROJECT_NAME.local
    DocumentRoot /var/www/html/$PROJECT_NAME/public
    <Directory /var/www/html/$PROJECT_NAME/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    LogLevel Warn
    ServerSignature Off
</VirtualHost>
EOF

### Enable the new virtual host ###
sudo a2ensite $PROJECT_NAME.conf
sudo systemctl reload apache2
