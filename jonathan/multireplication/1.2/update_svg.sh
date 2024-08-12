#!/usr/bin/env bash

docker exec sql-01 bash -c "mariadb-dump -u root -ppassword1234 --databases my_db >/mnt/data/mydb_dump.sql"

sleep 10

docker exec sql-svg bash -c "mariadb -u root -ppassword1234 </mnt/data/mydb_dump.sql"
