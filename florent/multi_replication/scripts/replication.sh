#!/usr/bin/env bash

DB_NAME="mydb"
PRIMARY="sql-01"
REPLICA="sql-svg-0"
TIMESTAMP=$(TZ='Europe/Paris' date +"%Y%m%d_%H%M%S")
BACKUP_FOLDER="/db_backup/$DB_NAME""__""$TIMESTAMP"
kubectl exec -it "$REPLICA" -- /bin/bash -c "mkdir -v -p $BACKUP_FOLDER && mariadb-dump -v -h $PRIMARY -u admin -proot $DB_NAME > $BACKUP_FOLDER/mydb.sql"