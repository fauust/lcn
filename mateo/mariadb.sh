#!/bin/bash

# Installation de MariaDB
apt update
apt install -y mariadb-server

# Démarrage et activation de MariaDB
systemctl start mariadb
systemctl enable mariadb

# Configuration de la base de données et de l'utilisateur
dbname="laraveldb"
dbuser="mateo-nicoud"
dbpass="123"

# Création de la base de données
mariadb -e "CREATE DATABASE IF NOT EXISTS $dbname;"

# Création de l'utilisateur s'il n'existe pas
mariadb -e "CREATE USER IF NOT EXISTS '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"

# Attribution des permissions sur la base de données
mariadb -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';"
mariadb -e "FLUSH PRIVILEGES"

# Sélection de la base de données
mariadb -e "USE $dbname;CREATE TABLE IF NOT EXISTS permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur VARCHAR(255) NOT NULL,
    permission VARCHAR(255) NOT NULL
);
"

# Insertion d'un élément dans la table permissions
mariadb -e "USE $dbname; INSERT INTO permissions (utilisateur, permission) VALUES ('mateo', 'admin');"
