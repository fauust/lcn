#!/usr/bin/env bash

set -x

# Install PHP
# ========================
#sudo apt-get install php-fpm php-common php-curl php-gd php-cli php-mysql php-mbstring php-xml
sudo apt-get install -y php8.2-fpm

# Enable PHP via FPM : FastCGI Process Manager
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm

# Create sample PHP file
# ========================
html_root="/var/www/testapache"
mkdir -p $html_root

cat > "$html_root"/index.php <<-EOF
<?php
    print("Hello World");
EOF


# Reload Apache
sudo systemctl reload apache2