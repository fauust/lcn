# Primary/Replica
---

# Guide de Test de Réplication

## Introduction

Ce guide explique comment vérifier que les deux réplicas répliquent correctement les données du serveur primaire dans une configuration Docker Compose avec MariaDB. Il décrit également comment tester la résilience de la réplication en coupant et redémarrant les serveurs.

## Prérequis

Assurez-vous que Docker et Docker Compose sont installés sur votre machine. Vous devez également avoir accès à WordPress via `http://localhost:8080`.

## Configuration

Fichier [docker-compose;yml](docker-compose.yml) utilisé

## Vérification de la Réplication

### 1. Vérifiez que les réplicas répliquent correctement le primaire

1. **Accédez à la base de données WordPress sur le primaire** :
    - Connectez-vous au conteneur du serveur primaire :
      ```bash
      docker exec -it sql-primary mysql -u root -p
      ```
    - Entrez le mot de passe `12321`.

2. **Vérifiez la réplication sur les réplicas** :
    - Connectez-vous à chaque réplicat :
      ```bash
      docker exec -it sql-replica01 mysql -u root -p
      docker exec -it sql-replica02 mysql -u root -p
      ```
    - Entrez le mot de passe `12321`.

    - Exécutez la commande suivante pour vérifier l'état de la réplication :
      ```sql
      SHOW SLAVE STATUS\G
      ```
    - Assurez-vous que `Slave_IO_Running` et `Slave_SQL_Running` sont tous deux à `Yes` sur les deux réplicas.

### 2. Testez la coupure d'un réplicat

1. **Arrêtez le conteneur du réplicat** :
   ```bash
   docker stop sql-replica1
   ```

2. **Vérifiez l'état de la réplication sur le primaire** :
    - Connectez-vous au primaire et insérez des données dans une table pour tester la réplication :
      ```sql
      USE wordpress;
      INSERT INTO wp_test (data) VALUES ('Test data');
      ```

3. **Redémarrez le réplicat** :
   ```bash
   docker start sql-replica01
   ```

4. **Vérifiez que la réplication reprend** :
    - Connectez-vous à `sql-replica1` et exécutez :
      ```sql
      SHOW SLAVE STATUS\G
      ```
    - Vérifiez que `Slave_IO_Running` et `Slave_SQL_Running` sont de nouveau à `Yes`.

    - Vérifiez également que les données insérées sur le primaire sont présentes sur le réplicat.

### 3. Testez la coupure du primaire

1. **Arrêtez le conteneur du primaire** :
   ```bash
   docker stop sql-primary
   ```

2. **Vérifiez que les réplicas continuent à fonctionner** :
    - Connectez-vous aux réplicats et vérifiez l'état de la réplication :
      ```bash
      docker exec -it sql-replica01 mysql -u root -p
      docker exec -it sql-replica02 mysql -u root -p
      ```
    - Exécutez `SHOW SLAVE STATUS\G` et vérifiez les valeurs des colonnes `Last_IO_Error` et `Last_SQL_Error`.

3. **Redémarrez le primaire** :
   ```bash
   docker start sql-primary
   ```

4. **Vérifiez que la réplication reprend** :
    - Connectez-vous à `sql-primary` et assurez-vous que la réplication reprend correctement sur les réplicats :
      ```bash
      docker exec -it sql-replica01 mysql -u root -p
      docker exec -it sql-replica02 mysql -u root -p
      ```
    - Exécutez `SHOW SLAVE STATUS\G` sur chaque réplicat et vérifiez que `Slave_IO_Running` et `Slave_SQL_Running` sont à `Yes`.

## Conclusion

Ce guide vous aide à vérifier que vos réplicas MariaDB fonctionnent correctement et que la réplication reprend normalement après une coupure du primaire ou d'un réplicat. Assurez-vous que vos conteneurs Docker sont configurés correctement et que les connexions réseau sont fonctionnelles pour garantir une réplication fluide.

Pour toute question ou problème, consultez la documentation officielle de MariaDB ou contactez le support technique.

---