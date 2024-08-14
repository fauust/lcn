# Primary/Primary

## 1. Lancer les conteneurs

Lancer les containers

```bash
docker compose up -d
```

## 2. Tester la Réplication

### 2.1 Créer une table sur sql-primary01

Exécutez la commande suivante pour créer une table test1 dans la base de données mydb2 sur sql-primary01

```
docker exec -it sql-primary01 mariadb -u root -pdbpassword -e "USE mydb2; CREATE TABLE test40 (nombre INT);"
```

### 2.2 Vérifier la réplication sur sql-primary02

Après avoir créé la table test1 sur sql-primary01.
Vérifiez que cette table a bien été répliquée sur sql-primary02 en listant les tables dans mydb2

```
docker exec -it sql-primary02 mariadb -u root -pdbpassword -e "USE mydb2; SHOW TABLES;"
```

### 2.3 Créer une nouvelle table sur sql-primary02

Pour tester la réplication dans l'autre sens, créez une nouvelle table test2 sur sql-primary02

```
docker exec -it sql-primary mariadb -u root -pdbpassword -e "USE mydb2; CREATE TABLE test50(i INT);"
```
### 2.4 Vérifier la réplication sur sql-primary01

Enfin, vérifiez que la table test2 a été répliquée de sql-primary02 vers sql-primary01

```
docker exec -it sql-primary01 mariadb -u root -pdbpassword -e "USE mydb2; SHOW TABLES;"
```

## 3. Arrêtrer les conteneurs

 ```
 docker-compose down
 ```