#!/usr/bin/env bash


sudo apt update
sudo apt install -y mariadb-server php-mysql
if [[ ! -f mariadb_user.sql ]]; then
	echo "could not find mariadb_user.sql"
	exit 1
fi

# shellcheck disable=SC2024
sudo mariadb <mariadb_user.sql

sudo rm /var/www/vm_app/.env
sudo mv .env /var/www/vm_app/

cd /var/www/vm_app/ || return
sudo systemctl restart apache2.service
sudo php artisan migrate
