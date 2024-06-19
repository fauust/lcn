#!/usr/bin/env bash

sudo apt install mycli -y
sudo apt install mariadb-server -y
sudo systemctl start mariadb.service




# en dessous ca bug askip
sudo mycli <<-EOF

CREATE USER 'eddy'@localhost IDENTIFIED BY 'eddy';

GRANT ALL PRIVILEGES ON *.* TO 'eddy'@'localhost';

FLUSH PRIVILEGES;

CREATE DATABASE toto;

use toto;

CREATE TABLE characters (first_name VARCHAR(255), last_name VARCHAR(255), age INT);

INSERT INTO characters SET first_name = 'Toto', last_name = 'Le Dingo', age = 9;

EXIT;
EOF