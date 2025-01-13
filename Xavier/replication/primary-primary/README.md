# Replication Primary-Primary

Database replication using Primary/Primary scheme

## Docker Containers
- `sql-primary01` : primary database 1 : used by Wordpress
- `sql-primary02` : primary database 2 : not used directly, but replicated from primary 1
- `wordpress` : holds the Wordpress application


Configure the Primary dbs
------------------------

Créer un fichier de conf `conf_primary1.cnf` qui indique la base de données à répliquer :

```text-plain
[mariadb]
log-bin
server_id=1
log-basename=primary1
binlog-format=mixed
binlog_do_db = wpd
```
Idem pour le 2e primary.

On crée les replication users pour chaque Primary db directement avec les variables d'environnement dans le Docker compose :

    ```text-plain
          - MARIADB_REPLICATION_USER=replication_user
          - MARIADB_REPLICATION_PASSWORD=titi
    ```


Configuring the MASTER / SLAVE replication
--------------------------------


Contrairement au setup "Primary-Replica", on ne peut cette fois pas mettre des variables d'environnement dans le Docker Compose pour configurer le MASTER de chaque Primary db. On doit le faire manuellement, avec un fichier SQL qui sera chargé grâce à l'entrypoint du Docker Compose.:

Exemple pour le Primary 1 : [setup_replication_p1.sql](setup_replication_p1.sql)
Ce fichier est exécuté au démarrage du container, grâce à la ligne suivante dans le Docker Compose :

```text-plain
    volumes:
      - ./setup_replication_p1.sql:/docker-entrypoint-initdb.d/setup_replication_p1.sql
```

```text-x-sql
CHANGE MASTER TO MASTER_HOST = "sql-primary02", MASTER_USER = "replication_user", MASTER_PASSWORD = "toto";
START SLAVE;
```

> Attention : ne pas utiliser "MASTER_USE_GTID = slave_pos", ça ne marche pas (l'utilisateur n'a pas les droits nécessaires)

Running the replicas
--------------------------------

Une fois les fichiers SQL de configuration chargés, la réplication se fait toute seule. On peut vérifier que tout fonctionne bien en se connectant à la base de données et en lançant les commandes suivantes :

```text-x-sql
SHOW SLAVE STATUS \G
```

If replication is working correctly, both the values of `Slave_IO_Running` and `Slave_SQL_Running` should be `Yes`:

```text-x-sql
Slave_IO_Running: Yes
Slave_SQL_Running: Yes
```

Make sure it works
------------------

*   create a post on Wordpress web interface (localhost:8080)
*   check database on Primary1
*   check database on Primary2 : it should be the same

Si on tue le container `sql-primary01`, le container `sql-primary02` peut prendre le relais - pour l'instant il faut faire le changement manuellement en modifiant le docker-compose.yml pour que wordpress pointe sur `sql-primary02`.
