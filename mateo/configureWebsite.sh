#!/bin/bash

[ -d /var/www/monprojet ] || sudo mkdir /var/www/monprojet
sudo chown -R mateo-nicoud:www-data /var/www/monprojet
sudo chmod -R 775 /var/www/monprojet
[ -d /var/www/monprojet/public ] || mkdir /var/www/monprojet/public
sudo chmod -R 775 /var/www/monprojet/public
sudo chown -R mateo-nicoud:www-data /var/www/monprojet/public
