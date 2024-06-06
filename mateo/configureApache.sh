#!/bin/bash

# Initialisation
sudo chmod -R 775 /etc/apache2/sites-available/
sudo chown -R root:www-data /etc/apache2/sites-available
sudo usermod -aG www-data mateo-nicoud
sudo echo '127.0.0.1 monprojet.local' | sudo tee -a /etc/hosts
