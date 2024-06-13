#!/usr/bin/env bash

# Variables
MDB_PASSWORD="test"
MDB_USER="ashevm"
DB_NAME="VMDB"
TABLE_NAME="Repertoire"
APACHE_LOG_DIR="/var/log/apache2"
HTML_ROOT="/var/www/blog.local"
VM_IP="192.168.122.32"
VHOST_FILE="/etc/apache2/sites-available/blog.conf"

# Update & Upgrade System
sudo apt update && sudo apt upgrade -y

# Install packages
apt install apache2 -y
apt install mariadb-server -y
systemctl enable mariadb
systemctl start mariadb

# Generate the SQL file from the template with variable substitution
cat <<EOF > /tmp/setup.sql
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MDB_USER}'@'localhost';
USE ${DB_NAME};
CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
FLUSH PRIVILEGES;
EOF

# Execute the SQL script
mariadb < /tmp/setup.sql

# Remove the temporary SQL file
rm /tmp/setup.sql


### PHP Installation ###
apt install -y php-fpm php-mysql php-sqlite3 curl php-cli php-mbstring php-xml git unzip
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
echo "restart php"
systemctl restart php8.2-fpm || { echo "Failed to restart PHP-FPM"; exit 1; }
echo "restart apache2"
systemctl restart apache2 || { echo "Failed to restart Apache"; exit 1; }

echo "done!!"
mkdir -p $HTML_ROOT
chown -R www-data:www-data $HTML_ROOT
chmod -R 755 $HTML_ROOT

echo "Creating virtual host configuration"
cat <<EOF > $VHOST_FILE
<VirtualHost *:80>
    ServerName blog.local
    ServerAdmin webmaster@${VM_IP}
    DocumentRoot $HTML_ROOT
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory $HTML_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF


a2ensite blog.local.conf
a2dissite 000-default.conf
systemctl reload apache2 || { echo "Failed to reload Apache"; exit 1; }
echo "Just test !"