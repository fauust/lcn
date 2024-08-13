#!/bin/bash

show_help() {
    echo "Usage: $0 value [-b] [-d]" >&2
    echo
    echo "   value: The value to insert into the database"
    echo "   -b: Rebuild the docker image"
    echo "   -d: Drop the existing containers/volumes"
    echo
    exit 1
}

if [ -z "$1" ]; then
    show_help
fi

value=$1
shift

build=""
drop=""

while getopts "bd" opt; do
    case $opt in
        b) build="true";;
        d) drop="true";;
        *) show_help;;
    esac
done

if [ "$build" == "true" ]; then
    docker build -t mariadb-replica . && sleep 10
fi

if [ "$drop" == "true" ]; then
    sudo rm -rf sql-01 && \
    sudo rm -rf sql-svg && \
    sudo rm -rf shared-data && \
    sudo rm -rf sql-01-backups && \
    sleep 1
fi

docker compose down && \
docker compose up -d && \
sleep 10

master_info=$(docker exec -i sql-01 mariadb -u root -p1234 -e "ALTER USER 'replica'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD ('123456789'); GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%'; FLUSH PRIVILEGES; SHOW MASTER STATUS\G")
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to get master status."
    exit 1
fi

echo "$master_info"
master_file=$(echo "$master_info" | grep "File:" | awk '{print $2}')
master_pos=$(echo "$master_info" | grep "Position:" | awk '{print $2}')

docker exec -i sql-svg mariadb -u root -p1234 -e "CHANGE MASTER TO MASTER_HOST='sql-01', MASTER_USER='replica', MASTER_PASSWORD='123456789', MASTER_LOG_FILE='$master_file', MASTER_LOG_POS=$master_pos; START SLAVE;"
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to set up slave."
    exit 1
fi

# shellcheck disable=SC2034
slave_status=$(docker exec -i sql-svg mariadb -u root -p1234 -e "SHOW SLAVE STATUS\G")
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to get slave status."
    exit 1
fi

docker exec -i sql-01 mariadb -u root -p1234 -e "USE mydb; CREATE TABLE IF NOT EXISTS user (id INT); INSERT INTO user (id) VALUES ($value);"
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to insert value into master."
    exit 1
fi

master_data=$(docker exec -i sql-01 mariadb -u root -p1234 -e "USE mydb; SELECT * FROM user;")
echo "Master Data:"
echo "$master_data"

slave_data=$(docker exec -i sql-svg mariadb -u root -p1234 -e "USE mydb; SELECT * FROM user;")
echo "Slave Data:"
echo "$slave_data"

# shellcheck disable=SC2034
final_slave_status=$(docker exec -i sql-svg mariadb -u root -p1234 -e "SHOW SLAVE STATUS\G")
# echo "$final_slave_status"

docker exec -i sql-01 backup.sh

function break_down {
    docker exec -it sql-01 mariadb -u root -p1234 -e "DROP DATABASE mydb;"
    echo "The node sql-01 no longer has the DB! Damned!"
}
# shellcheck disable=SC2012
latest_dump=$(ls -t ./sql-01-backups/mydb* | head -1)
break_down

# Recreate the database before restoring from backup
docker exec -i sql-01 mariadb -u root -p1234 -e "CREATE DATABASE mydb;"
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to create database mydb."
    exit 1
fi

docker exec -i sql-01 mariadb -u root -p1234 mydb < "$latest_dump"
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "Failed to restore database from backup."
    exit 1
fi

master_data=$(docker exec -i sql-01 mariadb -u root -p1234 -e "USE mydb; SELECT * FROM user;")
echo "Master Data:"
echo "$master_data"
