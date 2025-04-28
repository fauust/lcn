#!/bin/bash

set -uox

docker compose down --volumes
docker compose up --build --force-recreate -d

while ! docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;" &> /dev/null && \
    ! docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;" &> /dev/null; do
    echo "Waiting for sql-primary01 and sql-primary02 to be ready..."
    sleep 2
done
sleep 2

docker exec -it sql-primary01 rm -rf /var/mariadb/backup/01
docker exec -it sql-primary01 rm -rf /var/mariadb/backup/02
docker exec -it sql-primary01 mkdir -p /var/mariadb/backup/01
docker exec -it sql-primary02 mkdir -p /var/mariadb/backup/02

docker exec -it sql-primary01 mariadb -uroot -proot -e "STOP SLAVE;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "STOP SLAVE;"
docker exec -it sql-primary01 mariadb -uroot -proot -e "RESET MASTER;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "RESET MASTER;"

# docker exec -it sql-primary02 bash -c "mkdir -p /var/mariadb/backup/02/ && mariadb-backup --backup --target-dir=/var/mariadb/backup/02/ --user=mariadb_backup --password=mypassword && mariadb-backup --prepare --target-dir=/var/mariadb/backup/02/"
# docker exec -it sql-primary02 bash -c "service mariadb stop && mariadb-backup --copy-back --force-non-empty-directories  --target-dir=/var/mariadb/backup/02/ && chown -R mysql:mysql /var/lib/mysql && service mariadb start"

# item_count=$(docker exec -it sql-primary01 bash -c "mariadb -uroot -proot -e 'SELECT COUNT(*) FROM test_repl.hello;'" | awk 'NR==4' | tr -d ' '| tr -d '|')
# docker exec -it sql-primary02 mariadb -uroot -proot -e "UPDATE test_repl.hello SET id = id + $item_count WHERE id > 0;"

docker exec -it sql-primary02 bash -c "mariadb -uroot -proot -e 'SELECT msg FROM test_repl.hello;' > /var/mariadb/backup/02/hello_02.txt"
docker exec -it sql-primary02 bash -c 'awk '\''NR>1 {print "INSERT INTO test_repl.hello (msg) VALUES (\x27" $0 "\x27);"}'\'' /var/mariadb/backup/02/hello_02.txt > /var/mariadb/backup/02/hello_02_inserts.sql'
docker exec -it sql-primary02 mariadb -uroot -proot -e "TRUNCATE TABLE test_repl.hello;"
docker exec -it sql-primary02 mariadb -uroot -proot -e "ALTER TABLE test_repl.hello AUTO_INCREMENT = 0;"

docker exec -it sql-primary01 bash -c "mariadb -uroot -proot test_repl < /var/mariadb/backup/02/hello_02_inserts.sql"
docker exec -it sql-primary01  bash -c "mariadb -uroot -proot -e 'SELECT msg FROM test_repl.hello;' > /var/mariadb/backup/01/hello_01.txt"
docker exec -it sql-primary01 bash -c 'awk '\''NR>1 {print "INSERT INTO test_repl.hello (msg) VALUES (\x27" $0 "\x27);"}'\'' /var/mariadb/backup/01/hello_01.txt > /var/mariadb/backup/01/hello_01_inserts.sql'
docker exec -it sql-primary01 mariadb -uroot -proot -e "TRUNCATE TABLE test_repl.hello;"
docker exec -it sql-primary01 mariadb -uroot -proot -e "ALTER TABLE test_repl.hello AUTO_INCREMENT = 0;"

sleep 2

echo '# from replicat 01'
docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
echo '# from replicat 02'
docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"

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

docker exec -it sql-primary01 bash -c "mariadb -uroot -proot test_repl < /var/mariadb/backup/01/hello_01_inserts.sql"

docker exec -it sql-primary01 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary01');"
docker exec -it sql-primary02 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary02');"
echo '# from replicat 01'
docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
echo '# from replicat 02'
docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"

docker compose down --volumes
