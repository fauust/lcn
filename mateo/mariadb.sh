#!/bin/bash

# Installation de MariaDB
sudo apt update
sudo apt install -y mariadb-server

# Démarrage et activation de MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Configuration de la base de données et de l'utilisateur
dbname="laraveldb"
dbuser="mateo-nicoud"
dbpass="password"

# Création de la base de données
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $dbname;"

# Création de l'utilisateur s'il n'existe pas
sudo mysql -e "CREATE USER IF NOT EXISTS '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"

# Attribution des permissions sur la base de données
sudo mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES"

# Sélection de la base de données
sudo mysql -e "USE $dbname;CREATE TABLE IF NOT EXISTS permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur VARCHAR(255) NOT NULL,
    permission VARCHAR(255) NOT NULL
);
"
