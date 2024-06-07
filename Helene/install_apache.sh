#!/usr/bin/env bash

# Variables
MDB_PASSWORD="test"
MDB_USER="ashevm"

# Update & Upgrade System
sudo apt update && sudo apt upgrade -y

# Install packages
sudo apt install apache2 -y
sudo apt install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Generate the SQL file from the template with variable substitution
cat <<EOF > /tmp/setup.sql
CREATE USER '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MDB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Execute the SQL script
mariadb < /tmp/setup.sql

# Remove the temporary SQL file
rm /tmp/setup.sql
