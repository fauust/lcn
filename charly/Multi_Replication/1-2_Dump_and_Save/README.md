
#### 1. **`docker-compose.yml`**

```yaml
services:
  sql-01:
    image: mariadb
    container_name: sql-01
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password
      MYSQL_DATABASE: mydb
    volumes:
      - db_data_sql01:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  sql-svg:
    image: mariadb
    container_name: sql-svg
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password
      MYSQL_DATABASE: mydb
    volumes:
      - db_data_sqlsvg:/var/lib/mysql

volumes:
  db_data_sql01:
  db_data_sqlsvg:

```

#### 2. **Script d'Initialisation (`init.sql`)**

Le fichier `init.sql` permet de créer la base de données et d'insérer des données dans `sql-01` lors de son premier démarrage. Pour `sql-svg`, vous n'avez pas besoin d'un script d'initialisation supplémentaire si les données sont déjà présentes dans le volume partagé.

#### 3. **Processus de Sauvegarde et de Restauration**

Pour automatiser la sauvegarde et la restauration, vous devez vous assurer que les bases de données sont correctement initialisées et disponibles.

**Script de Sauvegarde (`dump_script.sh`)**

```bash
#!/bin/bash

while true; do
    docker run --rm --link sql-01:mysql -e MYSQL_ROOT_PASSWORD=your_root_password -v $(pwd)/backup:/backup mysql sh -c 'exec mysqldump -h mysql -u root -p"$MYSQL_ROOT_PASSWORD" mydb > /backup/mydb_backup_$(date +%F_%T).sql'
    sleep 120
done
```

### Diagramme

Voici un diagramme pour inclure les processus d'initialisation et de sauvegarde :

```
+----------------+         +-------------------+
|    Host System |         |     Docker Volume |
|                |         |   db_data         |
|                |         |                   |
|                |         |                   |
|                |         |                   |
+--------+-------+         +---------+---------+
         |                           |
         |                           |
         |                           |
+--------v---------+      +----------v---------+
|      sql-01      |      |       sql-svg       |
|  (MariaDB)       |      |    (MariaDB)        |
|  init.sql        |      |                     |
|  /var/lib/mysql  |      | /var/lib/mysql      |
+------------------+      +--------------------+
```

### Points Clés

- **Volume Partagé (`db_data`)** : Permet à `sql-svg` de partager les données de base de données avec `sql-01`. Cela garantit que les données sont disponibles même si un conteneur est arrêté.
- **Script d'Initialisation (`init.sql`)** : Assure que la base de données `mydb` est créée avec des tables et des données initiales lorsque `sql-01` démarre pour la première fois.
- **Sauvegarde et Restauration** : Utilisez le script de sauvegarde pour créer des dumps réguliers et restaurez les dumps lorsque nécessaire.


### Lancer le Projet avec Docker Compose

1. **Placez les fichiers** : Assurez-vous que `docker-compose.yml` et `init.sql` sont dans le même répertoire.

2. **Lancer Docker Compose** :

   Ouvrez un terminal et accédez au répertoire contenant vos fichiers. Exécutez la commande suivante pour démarrer les services :

   ```bash
   docker-compose up
   ```

   Cette commande télécharge les images Docker nécessaires (si elles ne sont pas déjà présentes), crée et démarre les conteneurs définis dans `docker-compose.yml`. Le conteneur `sql-01` exécutera automatiquement le fichier `init.sql` au démarrage, ce qui initialisera la base de données avec les tables et les données spécifiées.

### Étape 3 : Vérifier le Fonctionnement

1. **Vérifiez les conteneurs** : Assurez-vous que les conteneurs sont en cours d'exécution :

   ```bash
   docker ps
   ```

   Vous devriez voir les conteneurs `sql-01` et `sql-svg` en cours d'exécution.

2. **Se connecter à MariaDB** :
   - Pour vérifier que `sql-01` a correctement initialisé la base de données, vous pouvez vous connecter à `sql-01` avec le client MariaDB :

     ```bash
     docker exec -it sql-01 mariadb -u root -p
     ```

     Entrez le mot de passe `your_root_password` lorsque vous y êtes invité.

   - Vérifiez que la base de données `mydb` et la table `users` existent et contiennent les données :

     ```sql
     USE mydb;
     SHOW TABLES;
     SELECT * FROM users;
     ```

   - Pour vérifier `sql-svg`, vous pouvez utiliser la même commande :

     ```bash
     docker exec -it sql-svg mariadb -u root -p
     ```

     Et répétez les vérifications SQL ci-dessus.

### Gestion des Sauvegardes et Restauration

Pour les sauvegardes et la restauration :

1. **Sauvegarde Automatique** :
   - Créez un script de sauvegarde comme décrit précédemment et exécutez-le à l'aide de `cron` ou manuellement.

2. **Restauration** :
   - Assurez-vous que le conteneur `sql-svg` est opérationnel et que les volumes partagés contiennent les données nécessaires.
   - Pour restaurer une sauvegarde, exécutez :

     ```bash
     docker exec -i sql-svg mysql -u root -p your_root_password mydb < /path/to/backup/mydb_backup_latest.sql
     ```


###  **Configurer Cron**

Pour que le script s'exécute automatiquement, même si le script est déjà en boucle, vous pouvez choisir de lancer le script en tant que service ou utiliser `cron` pour démarrer le script à intervalles réguliers. Voici comment faire :

####  **Créer un Script de Démarrage**

1. **Créez un nouveau script** pour démarrer le script de sauvegarde, par exemple `start_dump_script.sh` :

    ```bash
    #!/bin/bash
    /path/to/dump_script.sh
    ```

2. **Rendez ce script exécutable** :

    ```bash
    chmod +x /path/to/start_dump_script.sh
    ```

#### **Ajouter une Tâche Cron**

1. **Ouvrez le fichier crontab** :

    ```bash
    crontab -e
    ```

2. **Ajoutez une entrée** pour exécuter le script `start_dump_script.sh` à chaque redémarrage de la machine ou à des intervalles spécifiques. Par exemple, pour démarrer le script au démarrage du système :

    ```bash
    @reboot /path/to/start_dump_script.sh
    ```

    Cela garantira que le script de sauvegarde est lancé automatiquement à chaque démarrage du système.

3. **Enregistrez et fermez** le fichier crontab.

###  **Vérifier le Fonctionnement**

- **Vérifiez les sauvegardes** pour vous assurer qu'elles sont créées correctement dans le répertoire `/backup`.
- **Consultez les logs de `cron`** si vous utilisez `cron` pour le démarrage automatique :

    ```bash
    grep CRON /var/log/syslog
    ```

### Remarques Supplémentaires

- **Gestion des Logs** : Étant donné que le script est en boucle infinie, il peut être utile de gérer les logs ou d'implémenter une gestion d'erreurs pour éviter les problèmes à long terme.
- **Ressources Système** : Assurez-vous que la sauvegarde fréquente n'affecte pas négativement les performances de votre système.
