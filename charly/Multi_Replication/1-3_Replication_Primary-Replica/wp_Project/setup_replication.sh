#!/bin/bash

# Configurations
PRIMARY_CONTAINER="sql-primary"
REPLICA_CONTAINER="sql-replica01"
REPL_USER="repl_user"
REPL_PASSWORD="repl_password"
ROOT_PASSWORD="test-password"
BACKUP_DIR="./backup"
LOG_FILE="$BACKUP_DIR/replication_setup.log"

# Assurer que le dossier de backup existe
mkdir -p $BACKUP_DIR

# 1. Créer un utilisateur de réplication sur le conteneur primaire
echo "Création de l'utilisateur de réplication sur le primaire..." | tee -a $LOG_FILE
docker exec $PRIMARY_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$REPL_USER'@'%' IDENTIFIED BY '$REPL_PASSWORD';" 2>&1 | tee -a $LOG_FILE
docker exec $PRIMARY_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "GRANT REPLICATION SLAVE ON *.* TO '$REPL_USER'@'%';" 2>&1 | tee -a $LOG_FILE
docker exec $PRIMARY_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "FLUSH PRIVILEGES;" 2>&1 | tee -a $LOG_FILE
docker exec $PRIMARY_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "FLUSH TABLES WITH READ LOCK;" 2>&1 | tee -a $LOG_FILE

# 2. Obtenir le statut du maître (nom du fichier binlog et position)
echo "Obtention du statut du maître..." | tee -a $LOG_FILE
MASTER_STATUS=$(docker exec $PRIMARY_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "SHOW MASTER STATUS\G" 2>&1)
echo "$MASTER_STATUS" | tee "$BACKUP_DIR/master_status.log" | tee -a $LOG_FILE

BINLOG_FILE=$(echo "$MASTER_STATUS" | grep "File:" | awk '{print $2}')
BINLOG_POSITION=$(echo "$MASTER_STATUS" | grep "Position:" | awk '{print $2}')

if [[ -z "$BINLOG_FILE" || -z "$BINLOG_POSITION" ]]; then
    echo "Erreur : Impossible d'obtenir les informations de statut du maître. Vérifiez la configuration du conteneur primaire." | tee -a $LOG_FILE
    exit 1
fi

echo "Fichier binlog : $BINLOG_FILE" | tee -a $LOG_FILE
echo "Position : $BINLOG_POSITION" | tee -a $LOG_FILE

# 3. Configurer le réplica
echo "Configuration du réplica..." | tee -a $LOG_FILE
docker exec $REPLICA_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "STOP SLAVE;" 2>&1 | tee -a $LOG_FILE
docker exec $REPLICA_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "CHANGE MASTER TO MASTER_HOST='$PRIMARY_CONTAINER', MASTER_USER='$REPL_USER', MASTER_PASSWORD='$REPL_PASSWORD', MASTER_LOG_FILE='$BINLOG_FILE', MASTER_LOG_POS=$BINLOG_POSITION;" 2>&1 | tee -a $LOG_FILE
docker exec $REPLICA_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "START SLAVE;" 2>&1 | tee -a $LOG_FILE

# 4. Vérification du statut de la réplication
echo "Vérification du statut du réplica..." | tee -a $LOG_FILE
REPLICA_STATUS=$(docker exec $REPLICA_CONTAINER mariadb -u root -p"$ROOT_PASSWORD" -e "SHOW SLAVE STATUS\G" 2>&1)
echo "$REPLICA_STATUS" | tee "$BACKUP_DIR/replica_status.log" | tee -a $LOG_FILE
echo "Configuration de la réplication terminée." | tee -a $LOG_FILE
