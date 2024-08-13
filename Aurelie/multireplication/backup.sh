#!/bin/bash

# VARIABLES
IP_CONTAINER="sql-01"

# Créer le répertoire /backup dans le conteneur sql-svg
docker exec sql-svg sh -c "mkdir -p /backup"

# Exécuter la commande mariad-dump pour créer la sauvegarde dans le conteneur sql-svg
docker exec sql-svg sh -c "mariadb-dump -uroot -pa -h ${IP_CONTAINER} mydb > /backup/mydb_$(date +"%Y%m%d%H%M").sql"