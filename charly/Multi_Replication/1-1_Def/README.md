
---

### 1. **Failover**
#### Mémo
Le **failover** est un mécanisme de basculement automatique qui permet de transférer la charge de travail d'un serveur ou d'un composant défaillant à un autre serveur de secours, assurant ainsi la continuité du service sans intervention manuelle.

#### Explication détaillée
- **Avantages** :
  - **Haute disponibilité** : En cas de panne du serveur principal, le serveur de secours prend immédiatement le relais, minimisant ainsi les interruptions de service.
  - **Redondance** : Garantit la disponibilité du système en fournissant un ou plusieurs serveurs de secours prêts à remplacer le serveur principal en cas de défaillance.
  - **Automatisation** : Le processus de failover est généralement automatisé, réduisant la dépendance aux interventions humaines et permettant une réponse rapide.

- **Inconvénients** :
  - **Coût élevé** : La mise en place d'un serveur de secours nécessite des ressources supplémentaires, ce qui peut être coûteux.
  - **Complexité de configuration** : La configuration du failover peut être complexe, nécessitant une expertise pour assurer une transition fluide.
  - **Synchronisation des données** : Assurer que les données du serveur de secours soient à jour peut être un défi, surtout si la réplication n'est pas bien configurée.

### 2. **Primary/Replica (Master/Slave)**
#### Mémo
Le modèle **Primary/Replica** consiste en un serveur principal (Primary) qui traite toutes les opérations d'écriture, tandis que les serveurs secondaires (Replicas) reçoivent une copie des données pour effectuer les opérations de lecture.

#### Explication détaillée
- **Avantages** :
  - **Scalabilité en lecture** : En distribuant les requêtes de lecture sur plusieurs réplicas, le système peut gérer un plus grand volume de requêtes simultanées sans surcharger le serveur principal.
  - **Réduction des charges sur le primaire** : Les serveurs réplicas déchargent le serveur principal en prenant en charge les opérations de lecture.
  - **Redondance et tolérance aux pannes** : En cas de panne du serveur principal, un des réplicas peut être promu au statut de primaire pour assurer la continuité du service.

- **Inconvénients** :
  - **Retard de réplication** : Les réplicas peuvent ne pas être immédiatement à jour par rapport au serveur primaire, ce qui peut entraîner des incohérences temporaires dans les données lues.
  - **Complexité de gestion** : La promotion d'un réplicat en serveur primaire en cas de panne peut être complexe et nécessiter une gestion manuelle ou un failover automatisé.
  - **Problèmes de cohérence** : Dans les systèmes asynchrones, la cohérence des données entre le primaire et les réplicas n'est pas garantie en temps réel, ce qui peut poser des problèmes dans certaines applications critiques.

### 3. **Primary/Primary (Multi-Master)**
#### Mémo
Dans une configuration **Primary/Primary**, plusieurs serveurs principaux (Masters) gèrent simultanément les écritures et les lectures, chacun répliquant les données aux autres serveurs.

#### Explication détaillée
- **Avantages** :
  - **Haute disponibilité** : Étant donné que tous les nœuds peuvent gérer les écritures, la défaillance d'un nœud n'affecte pas la capacité globale du système.
  - **Scalabilité horizontale** : Le système peut facilement évoluer en ajoutant de nouveaux nœuds, ce qui permet de répartir la charge de travail de manière plus équilibrée.
  - **Tolérance aux pannes** : La réplication entre plusieurs masters garantit que les données restent disponibles même si un nœud tombe en panne.

- **Inconvénients** :
  - **Gestion des conflits** : Lorsque plusieurs nœuds modifient les mêmes données simultanément, des conflits peuvent survenir, nécessitant une stratégie de résolution complexe.
  - **Complexité de mise en œuvre** : La synchronisation des données entre plusieurs masters est plus complexe que dans un modèle Primary/Replica, en raison de la nécessité de gérer la cohérence des données.
  - **Latence accrue** : La réplication des données entre plusieurs masters peut introduire une latence supplémentaire, surtout dans des environnements distribués géographiquement.

### 4. **Synchrone et asynchrone**
#### Mémo
La réplication **synchrone** exige que chaque opération d'écriture soit confirmée par tous les réplicas avant d'être validée, assurant ainsi une cohérence stricte des données. La réplication **asynchrone**, en revanche, permet de valider les écritures sans attendre que les réplicas aient reçu les mises à jour.

#### Explication détaillée
- **Avantages** :
  - **Réplication synchrone** :
    - **Cohérence forte** : Toutes les répliques sont garanties d'avoir les mêmes données en temps réel, ce qui est crucial pour des applications nécessitant une précision absolue.
    - **Résilience aux pannes** : En cas de défaillance d'un réplicat, les autres sont immédiatement à jour et peuvent continuer à fonctionner sans interruption.

  - **Réplication asynchrone** :
    - **Performance accrue** : La latence est réduite puisque l'écriture ne doit pas attendre que tous les réplicas confirment l'opération.
    - **Moins de surcharge réseau** : Moins de communication synchronisée entre les serveurs, ce qui peut réduire la charge sur le réseau.

- **Inconvénients** :
  - **Réplication synchrone** :
    - **Latence accrue** : Les opérations d'écriture peuvent être plus lentes car elles doivent attendre la confirmation de tous les réplicas.
    - **Moins de tolérance aux partitions réseau** : La perte de communication avec un réplicat peut bloquer les écritures tant que le réplicat n'est pas disponible.

  - **Réplication asynchrone** :
    - **Cohérence éventuelle** : Les réplicas peuvent être en retard par rapport au primaire, ce qui entraîne une incohérence temporaire des données.
    - **Risque de perte de données** : En cas de panne avant que les réplicas ne soient mis à jour, certaines données peuvent être perdues.

### 5. **Réplication par journaux (log shipping) / par système de fichiers**
#### Mémo
La réplication **par journaux** consiste à transférer les journaux de transactions d'une base de données vers un réplicat qui applique ces transactions pour se synchroniser. La réplication **par système de fichiers** implique la copie directe des fichiers de données d'un serveur à un autre.

#### Explication détaillée
- **Réplication par journaux** :
  - **Avantages** :
    - **Précision** : Seule la partie modifiée des données est transférée, ce qui rend la réplication plus efficace.
    - **Faible impact sur les performances** : Les journaux sont généralement plus légers à transférer que des fichiers complets, réduisant ainsi l'impact sur les performances du serveur.

  - **Inconvénients** :
    - **Complexité de mise en œuvre** : La configuration et la gestion des journaux peuvent être complexes, nécessitant une gestion rigoureuse pour éviter les pertes de données.
    - **Latence** : Les réplicas peuvent avoir un léger retard par rapport au serveur principal en fonction de la fréquence de l'application des journaux.

- **Réplication par système de fichiers** :
  - **Avantages** :
    - **Simplicité** : La réplication par système de fichiers est souvent plus simple à mettre en œuvre, car elle se base sur la copie brute des fichiers.
    - **Compatibilité** : Peut être utilisée avec n'importe quel système de stockage, quel que soit le format des données.

  - **Inconvénients** :
    - **Grande consommation de bande passante** : La copie des fichiers de grande taille peut consommer beaucoup de bande passante réseau, ce qui peut ralentir d'autres opérations.
    - **Cohérence moindre** : La réplication par système de fichiers ne garantit pas que les fichiers copiés soient cohérents à un instant donné, surtout s'ils sont en cours de modification.

### 6. **SQL/NoSQL**
#### Mémo
Les bases de données **SQL** (relational databases) utilisent un schéma structuré sous forme de tables, avec des relations définies entre les données, et s'appuient sur le langage SQL pour les requêtes. Les bases de données **NoSQL** sont plus flexibles, souvent sans schéma prédéfini, et sont adaptées pour stocker des données non structurées ou semi-structurées.

#### Explication détaillée
- **Bases de données SQL** :
  - **Avantages** :
    - **Cohérence et intégrité des données** : Les bases de données SQL respectent les propriétés ACID (Atomicité, Cohérence, Isolation, Durabilité), assurant la fiabilité des transactions.
    - **Langage standardisé** : SQL est un langage de requête standardisé, largement connu et utilisé, ce

 qui facilite le développement et la gestion.
    - **Schéma rigide** : Un schéma de données bien défini permet de maintenir la cohérence et l'intégrité des données.

  - **Inconvénients** :
    - **Scalabilité limitée** : Les bases de données SQL sont souvent plus difficiles à faire évoluer horizontalement (scalabilité horizontale) par rapport aux bases NoSQL.
    - **Rigidité du schéma** : Les changements dans la structure des données nécessitent des modifications du schéma, ce qui peut être compliqué et chronophage.
    - **Performance** : Peut être moins performante pour certaines opérations de lecture/écriture sur de très grands volumes de données.

- **Bases de données NoSQL** :
  - **Avantages** :
    - **Scalabilité horizontale** : Les bases NoSQL sont conçues pour évoluer horizontalement, ce qui permet de gérer facilement de très grands volumes de données en ajoutant simplement plus de serveurs.
    - **Flexibilité du schéma** : NoSQL permet de stocker des données de différentes structures sans avoir besoin de définir un schéma strict à l'avance.
    - **Adaptation aux données non structurées** : Convient particulièrement bien aux types de données non structurées ou semi-structurées comme les documents, les graphiques, etc.

  - **Inconvénients** :
    - **Cohérence éventuelle** : Contrairement aux bases SQL, de nombreuses bases NoSQL n'offrent pas les garanties de cohérence forte (ACID), ce qui peut poser des problèmes dans certaines applications critiques.
    - **Langages et interfaces propriétaires** : Les bases NoSQL n'ont pas de langage standardisé comme SQL, ce qui peut compliquer l'apprentissage et la migration d'une technologie à une autre.
    - **Complexité accrue pour les requêtes complexes** : Les bases de données NoSQL peuvent être moins efficaces pour des requêtes complexes qui nécessitent des jointures ou des transactions multi-tables.

---
