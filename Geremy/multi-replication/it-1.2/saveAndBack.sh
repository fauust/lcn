#! /usr/bin/env bash

timestamp=$(date +%s)

docker exec sql-01 bash -c "mariadb-dump --all-databases -uroot -ptest123 > /mnt/data/backup-db-"$timestamp".sql"

docker exec sql-svg bash -c "mariadb -u root -ptest123 < /mnt/data/backup-db-"$timestamp".sql"
