#!/bin/bash

# Variables
DUMP_DIR="/home/mateo-nicoud/Documents/Docker/backups"
DATE_FORMAT=$(date +%F_%H-%M-%S)
BACKUP_FILE="database_${DATE_FORMAT}.sql"

# Assurez-vous que le répertoire de sauvegarde existe
mkdir -p $DUMP_DIR

# Effectuer le dump
docker exec sql-01 sh -c "mariadb-dump -uroot -ph mydb > /var/backups/$BACKUP_FILE"

# Optionnel : Supprimer les fichiers de sauvegarde plus anciens que 7 jours
find $DUMP_DIR -type f -mtime +7 -name '*.sql' -exec rm {} \;

# Trouver le fichier de sauvegarde le plus récent
BACKUP_FILE=$(find "$DUMP_DIR" -maxdepth 1 -type f -name 'database_*.sql' -printf '%T+ %p\n' | sort -r | head -n 1 | awk '{print $2}')

# Restaurer la base de données dans sql-svg à partir du fichier de sauvegarde le plus récent
if [ -f "$BACKUP_FILE" ]; then
    echo "Restaurer la base de données à partir de $BACKUP_FILE"
    cp "$DUMP_DIR/$BACKUP_FILE" "$DUMP_DIR/../replica"
    docker exec sql-svg sh -c "mariadb -uroot -ph mydb < /var/backups/$BACKUP_FILE"
else
    echo "Aucun fichier de sauvegarde trouvé pour la restauration."
fi
