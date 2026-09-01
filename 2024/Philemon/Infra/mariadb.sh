#!/user/bin/env bash

DB_NAME="dbTest"
DB_USER="userTest"
DB_PASSWRD="test"


apt update -y
apt install mariadb-server -y
systemctl start mariadb.service
mariadb -u root <<-EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@localhost IDENTIFIED BY '$DB_PASSWRD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;
FLUSH PRIVILEGES;
EOF
