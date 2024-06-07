#!/usr/bin/env bash

# Variables
MDB_PASSWORD="test"
MDB_USER="ashevm"
DB_NAME="VMDB"
TABLE_NAME="Repertoire"

# Update & Upgrade System
sudo apt update && sudo apt upgrade -y

# Install packages
apt install apache2 -y
apt install mariadb-server -y
systemctl enable mariadb
systemctl start mariadb

# Generate the SQL file from the template with variable substitution
cat <<EOF > /tmp/setup.sql
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MDB_USER}'@'localhost';
USE ${DB_NAME};
CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Execute the SQL script
mariadb < /tmp/setup.sql

# Remove the temporary SQL file
rm /tmp/setup.sql


