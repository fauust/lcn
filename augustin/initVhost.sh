#!/usr/bin/env bash

sudo mkdir -p /var/www/TestingBasics

echo "<?php phpinfo(); ?>" | sudo tee /var/www/TestingBasics/info.php

sudo tee /etc/apache2/sites-available/TestingBasics.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin augustin@localhost
    ServerName TestingBasics.local
    DocumentRoot /var/www/html/TestingBasics/
    <Directory /var/www/html/TestingBasics/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.2-fpm.sock|fcgi://localhost/"
    </FilesMatch>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    LogLevel Warn
    ServerSignature Off
</VirtualHost>
EOF

sudo a2ensite TestingBasics

sudo systemctl reload apache2.service
sudo systemctl reload php8.2-fpm.service
