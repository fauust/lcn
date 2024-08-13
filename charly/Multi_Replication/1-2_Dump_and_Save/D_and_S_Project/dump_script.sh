#!/bin/bash

# Variables
BACKUP_DIR="/home/olinger/PycharmProjects/infra_vm_auto/lcn/charly/Multi_Replication/1-2_Dump_and_Save/D_and_S_Project/backup"
DB_NAME="mydb"
DB_CONTAINER="sql-01"
RESTORE_CONTAINER="sql-svg"

mkdir -p "$BACKUP_DIR"

# Vérifier si le conteneur de sauvegarde est en cours d'exécution
if ! docker ps | grep -q "$DB_CONTAINER"; then
  echo "Erreur : Le conteneur $DB_CONTAINER n'est pas en cours d'exécution. Les dockers sont éteints." >> "$BACKUP_DIR/backup_script.log"
  exit 1
fi

# Effectuer la sauvegarde en se connectant au conteneur de la base de données
if docker exec $DB_CONTAINER sh -c "mariadb-dump --defaults-extra-file=/root/.my.cnf $DB_NAME > /backup/mydb_backup_$(date +%F_%T).sql"; then
  echo "Sauvegarde réussie à $(date +%F_%T)" >> "$BACKUP_DIR/backup_script.log"
else
  echo "Erreur lors de la sauvegarde à $(date +%F_%T)" >> "$BACKUP_DIR/backup_script.log"
fi

# Supprimer les fichiers vides
find "$BACKUP_DIR" -type f -name '*.sql' -size 0 -exec rm -f {} \;

# Trouver le fichier de sauvegarde le plus récent
# shellcheck disable=SC2012
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.sql | head -n 1)

# Vérifier si le conteneur de restauration est en cours d'exécution
if ! docker ps | grep -q "$RESTORE_CONTAINER"; then
  echo "Erreur : Le conteneur $RESTORE_CONTAINER n'est pas en cours d'exécution. Les dockers sont éteints." >> "$BACKUP_DIR/restore_script.log"
  exit 1
fi

# Vérifier si le fichier de sauvegarde existe
if [ ! -f "$LATEST_BACKUP" ]; then
  echo "Erreur : Aucun fichier de sauvegarde trouvé." >> "$BACKUP_DIR/restore_script.log"
  exit 1
fi

# Copier le fichier de sauvegarde dans le conteneur de restauration
docker cp "$LATEST_BACKUP" "$RESTORE_CONTAINER:/backup/latest_backup.sql"

# Restaurer la base de données depuis le fichier de sauvegarde
if docker exec "$RESTORE_CONTAINER" sh -c "mariadb --defaults-extra-file=/root/.my.cnf $DB_NAME < /backup/latest_backup.sql"; then
  echo "Restauration réussie à $(date +%F_%T)" >> "$BACKUP_DIR/restore_script.log"
else
  echo "Erreur lors de la restauration à $(date +%F_%T)" >> "$BACKUP_DIR/restore_script.log"
fi

# Supprimer le fichier de sauvegarde du conteneur de restauration
docker exec "$RESTORE_CONTAINER" rm /backup/latest_backup.sql
