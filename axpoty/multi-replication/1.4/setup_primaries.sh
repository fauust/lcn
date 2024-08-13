#!/usr/bin/env bash

# CHANGE MASTER commands
docker exec sql-primary01 mariadb -uroot -ppassword1234 -e "CHANGE MASTER TO MASTER_HOST = 'sql-primary02', MASTER_USER = 'replication_user', MASTER_PASSWORD = 'replicapass', MASTER_PORT=3306, MASTER_USE_GTID=slave_pos, MASTER_CONNECT_RETRY=10;"
docker exec sql-primary02 mariadb -uroot -ppassword1234 -e "CHANGE MASTER TO MASTER_HOST = 'sql-primary01', MASTER_USER = 'replication_user', MASTER_PASSWORD = 'replicapass', MASTER_PORT=3306, MASTER_USE_GTID=slave_pos, MASTER_CONNECT_RETRY=10;"

# START SLAVE commands
docker exec sql-primary01 mariadb -uroot -ppassword1234 -e "START SLAVE;"
docker exec sql-primary02 mariadb -uroot -ppassword1234 -e "START SLAVE;"
