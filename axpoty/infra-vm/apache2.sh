#!/bin/bash

# Apache2
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y apache2

# Config

sudo cp vm-app.conf /etc/apache2/sites-available/vm-app.conf

sudo a2ensite vm-app.conf
sudo rm /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2
