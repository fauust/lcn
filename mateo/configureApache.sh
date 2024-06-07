#!/bin/bash

# Initialisation
sudo chmod -R 775 /etc/apache2/sites-available/ \
sudo chown -R root:www-data /etc/apache2/sites-available \
sudo usermod -aG www-data mateo-nicoud \
[ -d /var/www/monprojet ] || sudo mkdir /var/www/monprojet \
sudo chown -R mateo-nicoud:www-data /var/www/monprojet \
sudo chmod -R 775 /var/www/monprojet \
[ -d /var/www/monprojet/public ] || mkdir -p /var/www/monprojet/public \
sudo chmod -R 775 /var/www/monprojet/public \
sudo chown -R mateo-nicoud:www-data /var/www/monprojet/public \
sudo echo '127.0.0.1 monprojet.local' | sudo tee -a /etc/hosts
