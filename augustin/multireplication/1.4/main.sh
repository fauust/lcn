#!/bin/bash

set -euo pipefail

docker compose down --volumes
docker compose up --build --force-recreate -d

while ! docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT 1" &> /dev/null && \
    ! docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT 1" &> /dev/null; do
    echo "Waiting for sql-primary01 and sql-primary02 to be ready..."
    sleep 2
done

docker exec -it sql-primary01 mariadb -uroot -proot -e "STOP SLAVE;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "STOP SLAVE;"

docker exec -it sql-primary01 mariadb -uroot -proot -e "RESET MASTER;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "RESET MASTER;"

docker exec -it sql-primary01 mariadb -uroot -proot -e "
CHANGE MASTER TO
    MASTER_HOST='sql-primary02',
    MASTER_USER='repl',
    MASTER_PASSWORD='repl_pass',
    MASTER_PORT=3306,
    MASTER_USE_GTID=slave_pos;
START SLAVE;"

docker exec -it sql-primary02 mariadb -uroot -proot -e "
CHANGE MASTER TO
    MASTER_HOST='sql-primary01',
    MASTER_USER='repl',
    MASTER_PASSWORD='repl_pass',
    MASTER_PORT=3306,
    MASTER_USE_GTID=slave_pos;
START SLAVE;"

docker exec -it sql-primary01 mariadb -uroot -proot -e "SHOW SLAVE STATUS\G"
docker exec -it sql-primary02 mariadb -uroot -proot -e "SHOW SLAVE STATUS\G"

docker exec -it sql-primary01 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary01');"
docker exec -it sql-primary02 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary02');"

docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
