#! /usr/bin/env bash

docker exec -it sql-01 bash -c "mariadb -u root -ptest123 my-db < /data/Users.sql"
