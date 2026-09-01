#!/bin/bash

# Obtenir un timestamp pour nommer le fichier de sauvegarde
TIMESTAMP=$(date +"%Y%m%d%H%M%S") # Format: YYYYMMDDHHMMSS

# Effectuer le dump de la base de données et l'enregistrer dans /mnt/data
mariadb-dump -u root -pdbpassword mydb > /mnt/data/mydb_"$TIMESTAMP".sql

# Log de la réussite du backup
echo "Backup completed at $TIMESTAMP" >> /mnt/data/backup.log

# Injecter le dump dans le serveur MariaDB de sql-svg
mariadb -u root -pdbpassword mydb < /mnt/data/mydb_"$TIMESTAMP".sql

# Log de la réussite de l'injection
echo "SQL injection completed at $TIMESTAMP into sql-svg" >> /mnt/data/backup.log
