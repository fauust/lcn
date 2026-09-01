#!/usr/bin/env bash

DB_NAME="dbTest"
DB_USER="userTest"
DB_PASSWRD="test"

mariadb -u $DB_USER -p$DB_PASSWRD $DB_NAME <<-EOF
INSERT INTO comics_characters (name) VALUES ('Spider-Man');
INSERT INTO comics_characters (name) VALUES ('Batman');
INSERT INTO comics_characters (name) VALUES ('Wonder Woman');
EOF

