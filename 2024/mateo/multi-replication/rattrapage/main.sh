#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix

echo "Stopping and removing containers..."
docker compose down -v

echo "Starting containers..."
docker compose up -d

echo "Waiting for containers to start..."
sleep 30

echo "Checking replication status on primary01:"
SLAVE_STATUS_PRIMARY01=$(docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" ")
echo "$SLAVE_STATUS_PRIMARY01"

echo "Checking replication status on primary02:"
SLAVE_STATUS_PRIMARY02=$(docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" ")
echo "$SLAVE_STATUS_PRIMARY02"

if echo "$SLAVE_STATUS_PRIMARY01" | grep -q "Slave_SQL_Running: No"; then
  echo "Fixing replication on primary01..."
  docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"STOP SLAVE; SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1; START SLAVE;\" "
fi

if echo "$SLAVE_STATUS_PRIMARY02" | grep -q "Slave_SQL_Running: No"; then
  echo "Fixing replication on primary02..."
  docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"STOP SLAVE; SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1; START SLAVE;\" "
fi

echo "Waiting for replication to stabilize..."
sleep 5

SLAVE_IO_PRIMARY01=$(docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" " | grep "Slave_IO_Running:" | awk '{print $2}')
SLAVE_SQL_PRIMARY01=$(docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" " | grep "Slave_SQL_Running:" | awk '{print $2}')
SLAVE_IO_PRIMARY02=$(docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" " | grep "Slave_IO_Running:" | awk '{print $2}')
SLAVE_SQL_PRIMARY02=$(docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"SHOW SLAVE STATUS\\G\" " | grep "Slave_SQL_Running:" | awk '{print $2}')

if [[ "$SLAVE_IO_PRIMARY01" == "Yes" && "$SLAVE_SQL_PRIMARY01" == "Yes" && "$SLAVE_IO_PRIMARY02" == "Yes" && "$SLAVE_SQL_PRIMARY02" == "Yes" ]]; then
  echo "Réplication master-master configurée avec succès!"
else
  echo "La réplication n'est pas correctement configurée."
  exit 1
fi

# Test de réplication des tables
echo "Testing table replication between servers..."

# Créer une table de test sur primary01
echo "Creating test table on primary01..."
docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; CREATE TABLE IF NOT EXISTS replication_test (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255), timestamp DATETIME DEFAULT CURRENT_TIMESTAMP);\" "

# Insérer des données dans primary01
echo "Inserting data into primary01..."
docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; INSERT INTO replication_test (message) VALUES ('Test from primary01');\" "

# Attendre la réplication
echo "Waiting for replication to complete..."
sleep 5

# Vérifier si la table et les données existent sur primary02
echo "Checking if table and data exist on primary02..."
TABLE_EXISTS=$(docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='wordpress' AND table_name='replication_test';\" " | tail -1)
DATA_COUNT=$(docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; SELECT COUNT(*) FROM replication_test WHERE message='Test from primary01';\" " | tail -1)

if [[ "$TABLE_EXISTS" == "1" && "$DATA_COUNT" == "1" ]]; then
  echo "Table successfully replicated from primary01 to primary02!"
else
  echo "Table replication from primary01 to primary02 failed."
  exit 1
fi

# Maintenant, testons dans l'autre sens
echo "Testing replication in reverse direction..."

# Insérer des données dans primary02
echo "Inserting data into primary02..."
docker exec sql-primary02 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; INSERT INTO replication_test (message) VALUES ('Test from primary02');\" "

# Attendre la réplication
echo "Waiting for replication to complete..."
sleep 5

# Vérifier si les données existent sur primary01
echo "Checking if data exists on primary01..."
DATA_COUNT=$(docker exec sql-primary01 bash -c "mariadb -uroot -ppassword1234 -e \"USE wordpress; SELECT COUNT(*) FROM replication_test WHERE message='Test from primary02';\" " | tail -1)

if [[ "$DATA_COUNT" == "1" ]]; then
  echo "Data successfully replicated from primary02 to primary01!"
else
  echo "Data replication from primary02 to primary01 failed."
  exit 1
fi

echo "Réplication bidirectionnelle des tables vérifiée avec succès!"
