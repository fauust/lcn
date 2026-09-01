#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
source /tmp/config.sh

mariadb << EOF
USE $DB_NAME

CREATE TABLE IF NOT EXISTS USER (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO USER (name) VALUES ('azerty');
EOF