#!/bin/bash

### Variables ###
DB_ROOT_PASS="hugo"
DB_USER="hugouser"
DB_PASS="hugo"
PROJECT_NAME="hugovm"

### Update system ###
sudo apt update -y
sudo apt upgrade -y

### Install Apache and MariaDB ###
bash /home/$DB_USER/apache.sh $DB_USER $PROJECT_NAME
bash /home/$DB_USER/mariadb.sh $DB_ROOT_PASS $DB_USER $DB_PASS $PROJECT_NAME

### Install PHP extensions ###
sudo apt install -y apt-transport-https lsb-release ca-certificates wget
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
sudo apt install -y php8.3 php8.3-curl php8.3-xml php8.3-sqlite3 php8.3-mysql php8.3-zip

### Install Composer ###
cd ~ || exit
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

### Install Laravel ###
sudo apt install -y git
cd /var/www/html || exit
sudo mkdir $PROJECT_NAME
sudo chmod -R 775 $PROJECT_NAME
sudo chown -R www-data:www-data $PROJECT_NAME
composer create-project --prefer-dist laravel/laravel $PROJECT_NAME

### Set up .env file for Laravel ###
cd /var/www/html/$PROJECT_NAME || exit
cp .env.example .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=$PROJECT_NAME/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=$DB_PASS/" .env

### Generate application key and run migrations ###
sudo composer install
sudo php artisan key:generate
sudo php artisan migrate

### Final permissions and ownership ###
sudo chown -R www-data:www-data /var/www/html/$PROJECT_NAME
sudo chmod -R 775 /var/www/html/$PROJECT_NAME

echo "Laravel installation and configuration completed"
