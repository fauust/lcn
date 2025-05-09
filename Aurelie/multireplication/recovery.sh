#!/bin/bash

# Trouver le fichier le plus récent dans le répertoire /backup du conteneur sql-svg
latest_backup=$(docker exec sql-svg sh -c "ls -t /backup/mydb_*.sql | head -n 1")

# Afficher le fichier le plus récent pour vérification
echo "Fichier de sauvegarde le plus récent : $latest_backup"

# Créer la base de données si elle n'existe pas encore
docker exec sql-svg sh -c "mariadb -uroot -proot -e 'CREATE DATABASE IF NOT EXISTS mydb;'"

# Restaurer la base de données à partir du fichier le plus récent
docker exec -i sql-svg sh -c "mariadb -uroot -proot mydb" < <(docker exec sql-svg sh -c "cat $latest_backup")

echo "Restauration terminée avec succès."
