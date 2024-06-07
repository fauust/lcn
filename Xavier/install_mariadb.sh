#!/usr/bin/env bash

# Install Mariadb
# ========================
apt-get install -y mariadb-server mariadb-client

# Create a database and a user

user="xav"
passwd="1234"
database="db_xav"

mariadb -u root <<-EOF
CREATE DATABASE $database;
CREATE user '$user'@'localhost' IDENTIFIED BY '$passwd';
GRANT ALL ON $database.* TO '$user'@'localhost';
FLUSH PRIVILEGES;
USE $database;
CREATE TABLE contacts (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  age INT(3) NOT NULL,
  PRIMARY KEY  (id)
);
INSERT INTO contacts (name, age) VALUES ('Faustin', 35);
INSERT INTO contacts (name, age) VALUES ('Xavier', 38);
INSERT INTO contacts (name, age) VALUES ('Hugo', 60);
EOF

