# Guide de Configuration et Sauvegarde pour MariaDB avec Docker


Création d'un ficher docker-compose.yml pour creer deux containers : MariaDB sql-01 avec sa BDD mydb et sql-svg.

Créer un fichier [init-db.sql](init-db.sql) dans pour initer la base de donnée (créer db + tables) :

```
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(100) NOT NULL
);

INSERT INTO contacts (name, age, email) VALUES
    ('Alice', 30, 'alice@example.com'),
    ('Bob', 25, 'bob@example.com'),
    ('Charlie', 35, 'charlie@example.com'),
    ('Diana', 28, 'diana@example.com');

```
Démmarrer les containers et vérifier leur fonctionnement:
docker compose up -d
docker ps

Vérification des logs :
docker logs <nom-du-container>

Vérification BDD :
docker exec -it sql-01 mariadb -uroot -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;"

Création d'un script de sauvegarde [backup.sh](backup.sh)

Configurer une tâche cron pour exécuter la sauvegarde
Édite la crontab pour ajouter la tâche :
```
crontab -e
```
Ajouter la ligne suivante :
```
*/2 * * * * /root/docker-multirep/backup.sh
```

Utilisation de la commande cron depuis le container backup

Vérification des logs avant/ après arret du container sql-01
