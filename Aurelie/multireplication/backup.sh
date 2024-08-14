#!/bin/bash

# VARIABLES
#IP_CONTAINER="172.23.0.2"
IP_CONTAINER="sql-01"


# Mettre a jour le docker et installer mysql-client
docker exec sql-svg sh -c "apt-get update && apt-get install -y mysql-client"



# Créer le répertoire /backup dans le conteneur sql-svg
docker exec sql-svg sh -c "mkdir -p /backup"

# Exécuter la commande mariad-dump pour créer la sauvegarde dans le conteneur sql-svg
docker exec sql-svg sh -c "mysqldump -uadmin -pa -h ${IP_CONTAINER} mydb > /backup/mydb_$(date +"%Y%m%d%H%M").sql"