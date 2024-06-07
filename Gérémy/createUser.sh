#!/usr/bin/env bash

mariadb -e " INSERT INTO madb.users (name, email, password) VALUES ('durand', 'toto@gmail.com','156');"
