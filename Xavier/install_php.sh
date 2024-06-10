#!/usr/bin/env bash

set -x

# Install PHP
# ========================
# needed : php8.2-fpm, php-mysql (for database access)
sudo apt-get install -y php8.2-fpm php-mysql

# Enable PHP via FPM : FastCGI Process Manager
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.2-fpm

# Create sample PHP file
# ========================
html_root="/var/www/testapp"
mkdir -p $html_root

cat > "$html_root"/index.php <<-EOF
<?php
    print("Hello World");
EOF


# Reload Apache
sudo systemctl reload apache2