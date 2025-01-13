# 1.3 REPLICATION Primary / Replica

# Replication Primary / Replica

## Prérequis

- Docker et Docker Compose doivent être installés sur votre machine.

## Structure du Projet

- `docker-compose.yml` : Fichier de configuration Docker Compose pour lancer les conteneurs.
- `primary.cnf` : Configuration du serveur MariaDB principal (`sql-primary`).
- `replica01.cnf` : Configuration du premier réplica MariaDB (`sql-replica01`).
- `replica02.cnf` : Configuration du second réplica MariaDB (`sql-replica02`).
- `wp/` : Répertoire pour les fichiers WordPress.
- `sql-primary/` : Répertoire pour les données du serveur MariaDB principal.
- `sql-replica01/` : Répertoire pour les données du premier réplica.
- `sql-replica02/` : Répertoire pour les données du second réplica.

## Étapes pour Configurer et Lancer l'Environnement

### 1. Démarrage Initial

Lancez les conteneurs pour la première fois en utilisant Docker Compose :

```bash
docker-compose up -d
```

### 2. Configuration de WordPress

- Accédez à WordPress via `http://localhost:8080`.

### 3. Configurer la réplication

Accédez au serveur MariaDB principal (sql-primary) avec

```
docker exec -it sql-primary mariadb -u root -pdbpassword
```

Puis exécutez la commande suivante pour obtenir les informations de réplication

```
SHOW MASTER STATUS;
```

Prenez note des valeurs File et Position. Ensuite, exécutez

```
UNLOCK TABLES;
```

### 4. Configuration des réplicas

Accédez aux serveurs MariaDB des réplicas (sql-replica01 et sql-replica02) avec cette commande

```
docker exec -it sql-replica01 mariadb -u root -pdbpassword
```
Puis configurez la réplication en exécutant

```
STOP SLAVE;
CHANGE MASTER TO
MASTER_HOST='sql-primary',
MASTER_USER='replication_user',
MASTER_PASSWORD='replicapass',
MASTER_PORT=3306,
MASTER_LOG_FILE='primary01-bin.000004',
MASTER_LOG_POS=346;
START SLAVE;
```

Pour vérifier le statut des réplicas, exécutez :

```
SHOW SLAVE STATUS \G
```

### 5. Tester la Réplication

Créez une nouvelle base de données sur le serveur primaire pour vérifier que la réplication fonctionne

```
docker exec -it sql-primary mariadb -u root -pdbpassword -e "CREATE DATABASE test;"
```

Vérifiez que la nouvelle base de données est répliquée sur les deux réplicas en exécutant la commande suivante pour chaque réplica

```
docker exec -it sql-replica01 mariadb -u root -pdbpassword -e "SHOW DATABASES;"
docker exec -it sql-replica02 mariadb -u root -pdbpassword -e "SHOW DATABASES;"
```

### 6. Arrêt de l'Environnement

Pour arrêter tous les conteneurs

```
docker-compose down
```