#!/usr/bin/env bash

sudo mkdir -p /var/www/TestingBasics

echo "<?php phpinfo(); ?>" | sudo tee /var/www/TestingBasics/info.php

sudo tee /etc/apache2/sites-available/TestingBasics.conf > /dev/null <<EOF
<VirtualHost *:80>

    ServerAdmin augustin@localhost
    ServerName TestingBasics.local
    DocumentRoot /var/www/TestingBasics

    <Directory /var/www/TestingBasics/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
    LogLevel Warn

</VirtualHost>
EOF

sudo a2ensite TestingBasics

sudo systemctl reload apache2.service
sudo systemctl reload php8.2-fpm.service
