#!/bin/bash

# Vérifier si la base de données existe, sinon la créer
if ! mysql -h sql-01 -uroot -ppassword1234 -e 'USE wordpress'; then
  echo "La base de données 'wordpress' n'existe pas sur sql-01. Création de la base de données..."
  mysql -h sql-01 -uroot -ppassword1234 -e 'CREATE DATABASE wordpress'
fi

# Effectuer le dump de la base de données wordpress sur sql-01
# shellcheck disable=SC1001
mysqldump -h sql-01 -uroot -ppassword1234 wordpress > "/mnt/data/wordpress_$(date +\%F_\%T).sql"

# Restaurer la base de données wordpress dans sql-svg à partir du dernier dump
# shellcheck disable=SC2012
latest_dump=$(ls -t /mnt/data/wordpress_*.sql | head -n 1)
if [ -f "$latest_dump" ]; then
  mysql -h sql-svg -uroot -ppassword1234 wordpress < "$latest_dump"
fi
