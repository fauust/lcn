#!/usr/bin/env bash

docker exec -it sql-primary01 bash -c "mariadb -u root -ppassword1234 -e \"CHANGE MASTER TO MASTER_HOST='sql-primary02', MASTER_USER='replication_user', MASTER_PASSWORD='replicapass'\""
docker exec -it sql-primary02 bash -c "mariadb -u root -ppassword1234 -e \"CHANGE MASTER TO MASTER_HOST='sql-primary01', MASTER_USER='replication_user', MASTER_PASSWORD='replicapass'\""

for node in sql-primary01 sql-primary02; do
  docker exec -it $node bash -c "mariadb -u root -ppassword1234 -e 'start slave'"
  echo "show slave status ($node):"
  docker exec -it $node bash -c "mariadb -u root -ppassword1234 -e 'show slave status\G' | grep Running"
  echo ""
done
