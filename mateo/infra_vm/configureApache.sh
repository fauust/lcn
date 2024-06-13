#!/bin/bash

# Initialisation
chmod -R 775 /etc/apache2/sites-available/
chown -R root:www-data /etc/apache2/sites-available
usermod -aG www-data mateo-nicoud
echo '127.0.0.1 monprojet.local' >> /etc/hosts
