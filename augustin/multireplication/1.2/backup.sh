#!/bin/bash

TIMESTAMP=$(date +"%F_%T")
BACKUP_DIR="/backups"
BACKUP_FILE="$BACKUP_DIR/mydb_$TIMESTAMP.sql"

mkdir -p $BACKUP_DIR

mariadb-dump -h sql-01 -u root -p"$MYSQL_ROOT_PASSWORD" mydb > $BACKUP_FILE
