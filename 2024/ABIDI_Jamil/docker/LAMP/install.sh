#! /usr/bin/env bash
apt update;
apt install -y vim wget;
apt install -y apache2;
apt install -y mariadb-server mariadb-client;
DEBIAN_FRONTEND=noninteractive apt install -y php phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt install -y libapache2-mod-php php-mysql;
service apache2 restart;
cd /tmp && wget https://wordpress.org/latest.tar.gz;
tar -xvf latest.tar.gz;
cp -R wordpress /var/www/html/;
chown -R www-data:www-data /var/www/html/wordpress/;
chmod -R 755 /var/www/html/wordpress/;
mkdir /var/www/html/wordpress/wp-content/uploads;
chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/;
service apache2 restart;

