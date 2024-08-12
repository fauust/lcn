#!/bin/bash

# Variables
BACKUP_DIR="/home/olinger/PycharmProjects/infra_vm_auto/lcn/charly/Multi_Replication/1-2_Dump_and_Save/D_and_S_Project/backup"
MYSQL_ROOT_PASSWORD="Totodu26"
DB_NAME="mydb"
DB_CONTAINER="sql-01"

# Créer le répertoire de sauvegarde s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# Effectuer la sauvegarde en se connectant au conteneur de la base de données
if docker run --rm --link $DB_CONTAINER:mysql -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" -v "$BACKUP_DIR":/backup mysql sh -c "mysqldump -h mysql -u root -p\"$MYSQL_ROOT_PASSWORD\" $DB_NAME > /backup/mydb_backup_$(date +%F_%T).sql"; then
  echo "Sauvegarde réussie à $(date +%F_%T)" >> "$BACKUP_DIR/backup_script.log"
else
  echo "Erreur lors de la sauvegarde à $(date +%F_%T)" >> "$BACKUP_DIR/backup_script.log"
fi
