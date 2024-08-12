# 1.2 - DUMP & SAUVEGARDE

-----
## Structure des fichiers

- **`sql-01/`** : Contiendra les données de la base de données pour `sql-01`.
- **`sql-svg/`** : Contiendra les données de la base de données pour `sql-svg`.
- **`init-db.sql`** : Script SQL pour initialiser la base de données.
- **`backups/`** : Contiendra les fichiers de sauvegarde générés par `backup.sh`.
- **`backup.sh`** : Script pour effectuer la sauvegarde de la base de données

-----

## Pour crontab

Pour faire un cron -> `crontab -e`

```
*/2 * * * * /usr/bin/docker exec sql-svg /backup.sh >> /home/hugo/Desktop/VSC/multi_replication/1.2/backups/backup.log 2>&1
```

-----
## Lancement des containers

```
docker-compose up -d
```

## Pour véirfier la base de données

```
docker exec -it sql-svg mariadb -u root -pdbpassword -e "USE mydb; SHOW TABLES;"
```
