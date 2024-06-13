#!/bin/bash

[ -d /var/www/monprojet ] || sudo mkdir /var/www/monprojet
chown -R mateo-nicoud:www-data /var/www/monprojet
chmod -R 775 /var/www/monprojet
[ -d /var/www/monprojet/public ] || mkdir /var/www/monprojet/public
chmod -R 775 /var/www/monprojet/public
chown -R mateo-nicoud:www-data /var/www/monprojet/public
