#!/bin/bash
set -uox

wait() {
    container_names="$*"
    for container_name in $container_names; do
        while ! docker exec -it "$container_name" mariadb -uroot -proot -e "SELECT 1;" &> /dev/null; do
            echo "Waiting for $container_name to be ready..."
            sleep 1
        done
    done
    sleep 1
}
restart() {
    container_names="$*"
    for container_name in $container_names; do
        docker compose -f  ./docker-compose.backup-strategies.yml restart "$container_name"
        sleep 1
        wait "$container_name"
    done
}
stop() {
    container_names="$*"
    for container_name in $container_names; do
        docker compose -f  ./docker-compose.backup-strategies.yml stop "$container_name"
        sleep 1
    done
}

show_data() {
    docker exec -it sql-primary01 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
    docker exec -it sql-primary02 mariadb -uroot -proot -e "SELECT * FROM test_repl.hello;"
}

reset_volumes(){
    container_names="$*"
    pwd=$(pwd)
    if [[ " $container_names " == *" sql-primary01 "* ]]; then
        docker run --rm -v "$pwd/backup:/backup" -v "$pwd/mariadb01:/data01"  -v "$pwd/mariadb02:/data02" alpine:latest sh -c "
            rm -rf /data01/*  data01/.[!.]* /backup/01 && \
            mkdir -p /backup/01 "
    fi
    if [[ " $container_names " == *" sql-primary02 "* ]]; then
        docker run --rm -v "$pwd/backup:/backup" -v "$pwd/mariadb01:/data01"  -v "$pwd/mariadb02:/data02" alpine:latest sh -c "
            rm -rf /data02/* data02/.[!.]* /backup/02 && \
            mkdir -p /backup/01 "
    fi
}
input_dummy_data() {
    docker exec -it sql-primary01 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary01');"
    docker exec -it sql-primary02 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('Replication test from primary02');"
}
link_master_master(){
    docker exec -it sql-primary01 mariadb -uroot -proot -e "STOP SLAVE; RESET SLAVE; RESET MASTER"
    docker exec -it sql-primary02 mariadb -uroot -proot -e "STOP SLAVE; RESET SLAVE; RESET MASTER"

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
}
with_dump_strategy() {
    reset_volumes sql-primary01 sql-primary02

    docker compose -f  ./docker-compose.backup-strategies.yml down
    docker compose -f  ./docker-compose.backup-strategies.yml up  --build --force-recreate -d

    wait sql-primary01 sql-primary02

    docker exec -it sql-primary01 bash -c "mariadb -uroot -proot < /sql-scripts/replication-setup.sql"
    docker exec -it sql-primary02 bash -c "mariadb -uroot -proot < /sql-scripts/replication-setup.sql"

    docker exec sql-primary01 bash -c "\
    mariadb-dump -uroot -proot --all-databases --single-transaction > /var/mariadb/backup/01/snapshot.sql"

    docker exec -i sql-primary02 bash -c "\
    mariadb -uroot -proot < /var/mariadb/backup/01/snapshot.sql"

    link_master_master
    input_dummy_data
    show_data
    docker compose -f  ./docker-compose.backup-strategies.yml down
}

with_backup_stretegy(){
    reset_volumes sql-primary01 sql-primary02

    docker compose -f  ./docker-compose.backup-strategies.yml down
    docker compose -f  ./docker-compose.backup-strategies.yml up  --build --force-recreate -d

    wait sql-primary01 sql-primary02

    docker exec -it sql-primary01 bash -c "mariadb -uroot -proot < /sql-scripts/replication-setup.sql"
    docker exec -it sql-primary01 bash -c "mariadb-backup --backup --user=mariadb_backup --password=mypassword --target-dir=/var/mariadb/backup/01"

    stop sql-primary02
    reset_volumes sql-primary02
    pwd=$(pwd)
    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/data02" \
        mariadb:latest \
        bash -c "\
        chown mysql:mysql /data02"

    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/data02" \
        mariadb:latest \
        bash -c "\
        mariadb-backup --prepare --target-dir=/backup/01"

    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/var/lib/mysql" \
        mariadb:latest \
        bash -c "\
        mariadb-backup --copy-back --force-non-empty-directories  --target-dir=/backup/01/"

    restart sql-primary02

    link_master_master
    input_dummy_data
    show_data
    docker compose -f  ./docker-compose.backup-strategies.yml down
}
with_backup_restic_stretegy(){
    reset_volumes sql-primary01 sql-primary02

    docker compose -f  ./docker-compose.backup-strategies.yml down
    docker compose -f  ./docker-compose.backup-strategies.yml up  --build --force-recreate -d

    wait sql-primary01 sql-primary02

    docker exec -it sql-primary01 bash -c "mariadb -uroot -proot < /sql-scripts/replication-setup.sql"
    docker exec -it sql-primary01 bash -c "export RESTIC_REPOSITORY='/data/backup_restic' && export RESTIC_PASSWORD='mypassword' && restic init"
    docker exec -it sql-primary01 bash -c "export RESTIC_REPOSITORY='/data/backup_restic' && export RESTIC_PASSWORD='mypassword' && \
    mariadb-backup -uroot -proot --backup --stream=xbstream 2>/data/mariadb-backup.log | restic backup --stdin --stdin-filename mariadb.xb --tag MariaDB"
    docker exec -it sql-primary01 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('should be saved');"
    docker exec -it sql-primary01 bash -c "export RESTIC_REPOSITORY='/data/backup_restic' && export RESTIC_PASSWORD='mypassword' && \
    mariadb-backup -uroot -proot --backup --stream=xbstream 2>/data/mariadb-backup.log | restic backup --stdin --stdin-filename mariadb.xb --tag MariaDB"
    docker exec -it sql-primary01 mariadb -uroot -proot -e "INSERT INTO test_repl.hello (msg) VALUES ('should not be saved');"

    docker exec -it sql-primary01 bash -c "export RESTIC_REPOSITORY='/data/backup_restic' && export RESTIC_PASSWORD='mypassword' && \
    restic restore latest --target /var/mariadb/backup/ && cd /var/mariadb/backup/01 && \
    mbstream -x < /var/mariadb/backup/mariadb.xb && cd .. && rm -rf mariadb.xb"

    stop sql-primary02
    reset_volumes sql-primary02
    pwd=$(pwd)
    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/data02" \
        mariadb:latest \
        bash -c "\
        chown mysql:mysql /data02"

    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/data02" \
        mariadb:latest \
        bash -c "\
        mariadb-backup --prepare --target-dir=/backup/01"

    docker run --rm \
        -v "$pwd/backup:/backup" \
        -v "$pwd/mariadb02:/var/lib/mysql" \
        mariadb:latest \
        bash -c "\
        mariadb-backup --copy-back --force-non-empty-directories  --target-dir=/backup/01/"

    restart sql-primary02

    link_master_master
    input_dummy_data
    show_data
    docker compose -f  ./docker-compose.backup-strategies.yml down
}
# functional dump strategy
with_dump_strategy
# functional mariadb-backup strategy
with_backup_stretegy
# functional mariadb-backup-restic strategy
# sql-primary01 is used to create a backup and sql-primary02 is used to show how to restore the backup
# after backuping DDBs have diverged : it shows an example of data loss
# they can still be set as master-master replicas
with_backup_restic_stretegy
