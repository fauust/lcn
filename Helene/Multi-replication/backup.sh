#!/bin/bash
#Cron condition si les containers tournent
   if [ "$(docker inspect -f '{{.State.Running}}' sql-01)" = "true" ]; then
     docker exec sql-01 /usr/bin/mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" mydb > "$SQL_FILE"
   else
     echo "sql-01 is not running. Backup skipped."
   fi

TIMESTAMP=$(date +"%F-%H-%M-%S")
BACKUP_DIR=/mnt/data
SQL_FILE="$BACKUP_DIR/mydb-$TIMESTAMP.sql"
docker exec sql-01 /usr/bin/mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" mydb > "$SQL_FILE"

#Gzipper les .sql