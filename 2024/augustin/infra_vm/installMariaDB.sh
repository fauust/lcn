#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install mariadb-server -y

sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mariadb -u root <<EOF
CREATE DATABASE TestingBasics;
CREATE Table TestingBasics.users (id INT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255));
CREATE USER 'augustin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON TestingBasics.* TO 'augustin'@'localhost';
FLUSH PRIVILEGES;
EOF
sudo mysql -u augustin -p 'password' "insert into TestingBasics.users values (1, 'John Doe', 'john.doe@gmail.com');"
