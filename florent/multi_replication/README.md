# MULTI-RÉPLICATION

***Coming soon***

|TERMS|DEFS|
|----|----------|
|**Failover**|Opération de sauvegarde dans laquelle les fonctions d'un système (processeur, serveur, réseau, bdd...) sont assurées par les cmposants d'un système secondaire, lorsque le premier devient indisponible, soit à la suite d'une panne, soit en raison d'une interruption planifiée.<br><br>[https://www.lemagit.fr/definition/Failover-basculement]|
|**Primary / Replica**|En Primary / Replica (Master-Slave), un serveur (Primary / Master) gère toutes les opérations d'écriture. Les modifications sont ensuite répliquées sur un ou plusieurs autre serveurs (Replica / Slave).<br><br>[https://www.designgurus.io/answers/detail/what-is-primary-replica-vs-peer-to-peer-replication]|
|**Primary / Primary**|En Primary / Primary (Peer-to-Peer), chaque nœud (pair) du réseau peut agir à la fois comme client et comme serveur. Les pairs ont les mêmes privilèges et peuvent lancer ou terminer les processus de réplication.<br><br>[https://www.designgurus.io/answers/detail/what-is-primary-replica-vs-peer-to-peer-replication]|
|**Synchrone / Asynchrone**|**Synchrone**:<br>Les données sont d'abord écrites sur la matrice du site primaire, puis immédiatement répliquées sur la matrices du site secondaire.<br>Les écriture ne sont considérées comme terminées que lorsque l'hôte reçoit un accusé de réception indiquant que le processus d'écriture est terminé sur la matrices des deux sites.<br>Bien que cela garantisse l'absence ou la quasi-absence de divergence entre les données des sites primaires et secondaires, le processus peut peser sur les performances globales et peut également avoir un impact négatif si la distance entre les sites primaires et secondaires est importante.<br><br>**Asynchrone**:<br>Les données sont écrites sur le site primaire, puis répliquées périodiquement sur un site secondaire, ce qui peut se produire toutes les heures, tous les jours ou toutes les semaines. Une fois le site secondaire mis à jour, un accusé de réception est envoyé au site primaire.<br>Étant donné que les données sont écrites de manière asynchrone, les utilisateurs peuvent programmer la réplication à des moments où les performances du réseau seront les moins affectées.<br>Le site secondaire peut être utilisé pour la reprise après sinistre, sous entendu que les sites primaire et secondaire peuvent ne pas être entièrement synchronisés.<br><br>[https://www.cohesity.com/fr/glossary/data-replication/]|
|**Per journals / Per file system**|***TO DO...***|
|**SQL / NoSQL**|**SQL**:<br>Base de données relationnelle qui organise les données dans des tableaux (lignes / colonnes).<br><br>- Les données sont stockées dans des tables, où chaque ligne représente un enregistrement, et chaque colonne un attribut de cet enregistrement.<br>- Les relations entre les tables sont appliquées grâce à l'utilisation de clés étrangères. Cela garantit l'intégrité et réduit la redondance des données.<br>- Le langage SQL est utilisé pour interroger et manipuler les données.<br>- Les propriétés ACID (Atomicité, Cohérence, Isolation, Durabilité) sont appliquées pour garantir la fiabilité et l'intégrité des données. Les transactions se terminent complètement ou pas du tout.<br><br><br>**NoSQL**:<br>Base de données non relationnelle qui stocke les données dans un format autre que celle d'une table. Elles sont disponibles dans une variété de types en fonction de leur modèle de données.<br><br>- Les données sont stockées dans un format non structuré avec une clé unique pour récupérer les valeurs (ex: **Redis** et **DynamoDB**).<br>- Les données sont stockées au format document, tel que JSON (ex: **MongoDB** et **CouchDB**).<br>- Les données sont stockées dans des nœuds et des arêtes, optimisées pour les relations de données (ex: **Neo4j** et **JanusGraph**).<br>- Les donénes sont stockées dans des colonnes au lieu de lignes (ex: **Cassandra** et **HBase**).<br><br>[https://www.astera.com/fr/knowledge-center/sql-vs-nosql/]|

---

### KUBERNETES

|CMDS|DEFS|
|---|---|
|`kubectl get pods`|Show PODS|
|`kubectl exec -it <pod_name> -- <command>`|Access to POD<br>**ex**: `kubectl exec -it mypod -- /bin/bash`|
|`kubectl apply -k .`|Launched YAML files<br><br>`-k` for launched `kustomization.yml` which includes several YAML files<br><br>`.` for path|

---

### ANNEXES

#### IN KUBERNETES CONTAINER

##### >>> MySQL <<<

|CMDS|DEFS|
|---|---|
|`mysql -u <user> -p<password>`|Access to MySQL|
|MariaDB [(none)]> `show databases;`|Show databases|
|MariaDB [(none)]> `use <db_name>;`|Select database for used|
|MariaDB [<db_name>]> `SELECT * FROM <table_name>;`|Show all table content|