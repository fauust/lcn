#!/usr/bin/env bash

set -e

timestamp=$(date +%F_%T)

# Check if sql-01 container is running
if docker ps --format '{{.Names}}' | grep -q 'sql-01'; then
  # backup db
  docker exec sql-01 bash -c "mariadb-dump -v --all-databases -u root -ptest123 > /shared-data/backup-db-$timestamp.sql"
  # appear in the logs journalctl -f
  logger "Backup completed for sql-01 at $timestamp."
else
  logger "Container sql-01 is not running. Skipping backup."
  exit 1
fi

# Check if sql-svg container is running
if docker ps --format '{{.Names}}' | grep -q 'sql-svg'; then
  # restoring db with the backup created.
  docker exec sql-svg bash -c "mariadb mydb -v -u root -ptest123 < /shared-data/backup-db-$timestamp.sql"
  # appear in the logs journalctl -f
  logger "Database restoration started for sql-svg at $timestamp."
else
  logger "Container sql-svg is not running. Skipping restore."
fi

