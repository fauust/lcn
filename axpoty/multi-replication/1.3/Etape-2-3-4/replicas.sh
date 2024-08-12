#!/usr/bin/env bash

# Stop the replicas
docker exec -it sql-replica01 mariadb -uroot -ppassword -e "STOP SLAVE"
docker exec -it sql-replica02 mariadb -uroot -ppassword -e "STOP SLAVE"

# Get SHOW MASTER STATUS File from the primary
docker exec -it sql-primary mariadb -uroot -ppassword -e "SHOW MASTER STATUS \G" | grep File | cut -d':' -f2 | tr -d ' ' >/tmp/master_status_file

# Init the replica with the primary
docker exec -it sql-replica01 mariadb -uroot -ppassword -e "CHANGE MASTER TO MASTER_HOST='sql-primary', MASTER_USER='replication_user', MASTER_PASSWORD='bigs3cret', MASTER_LOG_FILE='$(cat /tmp/master_status_file)', MASTER_LOG_POS=4;"
docker exec -it sql-replica02 mariadb -uroot -ppassword -e "CHANGE MASTER TO MASTER_HOST='sql-primary', MASTER_USER='replication_user', MASTER_PASSWORD='bigs3cret', MASTER_LOG_FILE='$(cat /tmp/master_status_file)', MASTER_LOG_POS=4;"

# Set the GTID mode on the replicas
docker exec -it sql-replica01 mariadb -uroot -ppassword -e "CHANGE MASTER TO MASTER_USE_GTID = slave_pos"
docker exec -it sql-replica02 mariadb -uroot -ppassword -e "CHANGE MASTER TO MASTER_USE_GTID = slave_pos"

# Start the replicas
docker exec -it sql-replica01 mariadb -uroot -ppassword -e "START SLAVE"
docker exec -it sql-replica02 mariadb -uroot -ppassword -e "START SLAVE"
