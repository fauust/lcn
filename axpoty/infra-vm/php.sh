#!/bin/bash

### Sources
sudo apt install -y curl lsb-release

# Add PHP source and signing key along with dependencies
sudo apt install -y apt-transport-https
sudo curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt update -y

# Install FPM
sudo apt install -y php8.3-fpm

# Install new PHP 8.3 packages
sudo apt install -y php8.3 php8.3-{cli,xml,dom,zip,mysql,bz2,curl,mbstring,intl}
