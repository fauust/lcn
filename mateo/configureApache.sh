#!/bin/bash

# Variables
USER="mateo-nicoud"
HOST="192.168.122.240"
KEY_PATH="/home/mateo-nicoud/.ssh/vb"
PASSWORD="password"
#INSTALL_COMMAND="sudo apt-get install -y"

export SSHPASS="$PASSWORD"
# Supprimer l'entrée du host dans le fichier known_hosts
ssh-keygen -f "/home/mateo-nicoud/.ssh/known_hosts" -R "$HOST"
chown mateo-nicoud:mateo-nicoud /home/mateo-nicoud/.ssh/known_hosts
sudo sed -i 's/^deb cdrom/#deb cdrom/' /etc/apt/sources.list

# Authentication SSH
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "\
sudo chmod -R 775 /etc/apache2/sites-available/ \
&& sudo chown -R root:www-data /etc/apache2/sites-available"
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no "/home/mateo-nicoud/Documents/infraVm/monprojet.conf" "$USER@$HOST:/etc/apache2/sites-available/monprojet.conf"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "\
sudo usermod -aG www-data mateo-nicoud \
&& [ -d /var/www/monprojet ] || sudo mkdir /var/www/monprojet \
&& sudo chown -R www-data:www-data /var/www/monprojet \
&& sudo chmod -R 775 /var/www/monprojet \
&& sudo a2ensite monprojet \
&& sudo apt-get install -y php-xml \
&& sudo apt-get install -y php-dom \
&& sudo sudo systemctl reload apache2 \
&& sudo composer create-project --prefer-dist laravel/laravel /var/www/monprojet \
"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "sudo composer install -d /var/www/monprojet"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "echo '127.0.0.1 monprojet.local' | sudo tee -a /etc/hosts"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "sudo systemctl reload apache2.service"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST" "source ~/.bashrc && nvm install node"
#sudo a2enmod proxy_fcgi setenvif
#&& wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
#&& nvm install node \