#!/usr/bin/env bash

DB_NAME="dbTest"
DB_USER="userTest"
DB_PASSWRD="test"


echo "this is $0"
mariadb -u $DB_USER -p$DB_PASSWRD $DB_NAME <<-EOF
CREATE TABLE IF NOT EXISTS comics_characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "done"
