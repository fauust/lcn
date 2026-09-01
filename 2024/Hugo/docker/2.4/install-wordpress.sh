#!/bin/bash

# Attendre que MySQL soit prêt
until mysqladmin ping -h db --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

# Télécharger WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configurer WordPress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sed -i "s/password_here/wordpresspassword/" /var/www/html/wp-config.php
sed -i "s/localhost/db/" /var/www/html/wp-config.php

# Démarrer le serveur Apache en avant-plan
apache2-foreground
