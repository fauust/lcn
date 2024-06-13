#!/usr/bin/env bash

DB_USER="aurelie"
DB_PASS="campus"
DB_NAME="contacts_db"

#shellcheck disable=SC2024
sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < create_contact_table.sql
