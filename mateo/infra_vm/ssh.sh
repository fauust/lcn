#!/bin/bash

USER="mateo-nicoud"
HOST="192.168.122.240"
KEY_PATH="/home/$USER/.ssh/vb"

# Supprimer l'entrée du host dans le fichier known_hosts
ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R "$HOST"
chown mateo-nicoud:mateo-nicoud /home/mateo-nicoud/.ssh/known_hosts

# Envoie des scripts
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no mariadb.sh $USER@$HOST:
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no configureApache.sh $USER@$HOST:
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no reload.sh $USER@$HOST:
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no configureWebsite.sh $USER@$HOST:

# Execution des scripts apache2 et mariadb
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no $USER@$HOST "sudo bash ./configureApache.sh"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no $USER@$HOST "sudo bash ./mariadb.sh"

# Envoie du fichier conf apache2
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no "monprojet.conf" "$USER@$HOST:/etc/apache2/sites-available/monprojet.conf"

# Envoie du site
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no $USER@$HOST "sudo bash ./configureWebsite.sh"
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no "index.php" "$USER@$HOST:/var/www/monprojet/public/index.php"


# Reload final
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no $USER@$HOST "sudo bash ./reload.sh"


