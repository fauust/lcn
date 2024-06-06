#!/bin/bash

sudo a2ensite monprojet \

# Reload pour que apache2 prenne en compte les changement
sudo systemctl reload apache2.service
