#! /usr/bin/env bash
sudo apt update && sudo apt upgrade -y
# sudo apt install -y lsb-release apt-transport-https ca-certificates
# sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list'
# wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
sudo apt install php8.2-fpm php8.2-xml -y
sudo apt-get install php-mysql -y

sudo systemctl enable php8.2-fpm
sudo systemctl start php8.2-fpm

sudo a2dismod php8.2 mpm_prefork
sudo a2enmod proxy_fcgi setenvif mpm_event
a2dissite 000-default

sudo a2enconf php8.2-fpm

sudo systemctl restart apache2
sudo systemctl reload apache2