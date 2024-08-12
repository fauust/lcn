#!/bin/sh

# Installer le client MySQL pour les opérations de dump
apk add --no-cache mysql-client bash

# Créer le script de sauvegarde
cat << 'EOF' > /scripts/mysqldump.sh
#!/bin/bash

# Vérifier si la base de données existe, sinon la créer
if ! mysql -h sql-01 -uroot -ppassword1234 -e 'USE wordpress'; then
  echo "La base de données 'wordpress' n'existe pas sur sql-01. Création de la base de données..."
  mysql -h sql-01 -uroot -ppassword1234 -e 'CREATE DATABASE wordpress'
fi

# Effectuer le dump de la base de données wordpress sur sql-01
mysqldump -h sql-01 -uroot -ppassword1234 wordpress > /mnt/data/wordpress_$(date +\%F_\%T).sql

# Restaurer la base de données wordpress dans sql-svg à partir du dernier dump
latest_dump=$(ls -t /mnt/data/wordpress_*.sql | head -n 1)
if [ -f "$latest_dump" ]; then
  mysql -h sql-svg -uroot -ppassword1234 wordpress < "$latest_dump"
fi
EOF

chmod +x /scripts/mysqldump.sh

# Configurer le cron job pour exécuter le script toutes les 2 minutes
echo "*/2 * * * * /scripts/mysqldump.sh" >> /etc/crontabs/root

# Démarrer le cron daemon
crond -f -l 2
