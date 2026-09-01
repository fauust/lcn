#!/bin/bash

# Variables
MASTER_CONTAINER="sql-primary"
REPLICA_CONTAINER="sql-replica01"
MASTER_ROOT_PASSWORD="password1234"
REPLICA_ROOT_PASSWORD="password1234"
REPLICATION_USER="replication_user"
REPLICATION_PASSWORD="password1234replica"


# 1. Configurer le maître
MASTER_STATUS=$(docker exec $MASTER_CONTAINER mariadb -uroot -p$MASTER_ROOT_PASSWORD -e "GRANT REPLICATION SLAVE ON *.* TO '$REPLICATION_USER'@'%' IDENTIFIED BY '$REPLICATION_PASSWORD'; FLUSH PRIVILEGES; FLUSH TABLES WITH READ LOCK; SHOW MASTER STATUS\G")

# 2. Extraire les valeurs File et Position
MASTER_LOG_FILE=$(echo "$MASTER_STATUS" | grep 'File:' | awk '{ print $2 }')
MASTER_LOG_POS=$(echo "$MASTER_STATUS" | grep 'Position:' | awk '{ print $2 }')

# 3.Vérification
if [ -z "$MASTER_LOG_FILE" ] || [ -z "$MASTER_LOG_POS" ]; then
  echo "Erreur : Impossible d'obtenir les valeurs MASTER_LOG_FILE et MASTER_LOG_POS."
  exit 1
fi


# 4. Configurer le réplica
docker exec $REPLICA_CONTAINER mariadb -uroot -p$REPLICA_ROOT_PASSWORD -e "CHANGE MASTER TO MASTER_HOST='$MASTER_CONTAINER', MASTER_USER='$REPLICATION_USER', MASTER_PASSWORD='$REPLICATION_PASSWORD', MASTER_LOG_FILE='$MASTER_LOG_FILE', MASTER_LOG_POS=$MASTER_LOG_POS; START SLAVE;"

# 5. Vérifier l'état de la réplication
docker exec $REPLICA_CONTAINER mariadb -uroot -p$REPLICA_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G"

echo "Configuration de la réplication maître-esclave terminée."
