#!/bin/bash
# Script to connect to mariadb-primary and dump it to backup folder every 2 minutes

# Variables
BACKUP_DIR="/backups"
DATE=$(date +"%Y-%m-%d-%H-%M")
ROOT_PASSWORD="root"
PRIMARY_HOST="sql-01"

# Create backup directory
mkdir -p $BACKUP_DIR

# Dump database to backup folder
mariadb-dump -uroot -p$ROOT_PASSWORD -h$PRIMARY_HOST --all-databases >$BACKUP_DIR/$DATE.sql

## DEBUG
# Check if dump is successful
#if [ $? -eq 0 ]; then
#	echo "Backup successful"
#else
#	echo "Backup failed"
#fi
#
## List backup files
#ls $BACKUP_DIR
