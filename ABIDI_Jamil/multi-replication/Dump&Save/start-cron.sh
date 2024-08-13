#!/bin/sh

# Installer les dépendances
apk add --no-cache mysql-client bash

# Créer le script de sauvegarde
cat << 'EOF' > /mysqldump.sh
#!/bin/bash
mysqldump -h mariadb -uroot -prootpassword --databases mydb > /dumps/mydb_$(date +\%F_\%T).sql
EOF

chmod +x /mysqldump.sh

# Configurer le cron job
echo "*/2 * * * * /mysqldump.sh" >> /etc/crontabs/root

# Démarrer le cron
crond -f -l 2
