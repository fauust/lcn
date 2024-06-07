#!/bin/bash

sudo apt install -y mariadb-server

# shellcheck disable=SC2024
sudo mysql <./create_user.sql

cd /var/www/vm-app || exit

sudo sed -i 's/DB_CONNECTION=.*/DB_CONNECTION=mysql/' .env
sudo sed -i 's/# DB_DATABASE=.*/DB_DATABASE=vm_app/' .env
sudo sed -i 's/# DB_USERNAME=.*/DB_USERNAME=axpoty/' .env
sudo sed -i 's/# DB_PASSWORD=.*/DB_PASSWORD=1234/' .env
sudo sed -i 's/# DB_HOST=.*/DB_HOST=localhost/' .env
sudo sed -i 's/# DB_PORT=.*/DB_PORT=3306/' .env

sudo systemctl restart mariadb
sudo php artisan migrate
