# Mémo : Différentes Méthodes de Réplication des Données

## 1\. **Failover**

- **Définition** : Le failover est un mécanisme qui permet de basculer automatiquement vers un système de secours en cas de panne du système principal. Ce n'est pas une réplication à proprement parler, mais une stratégie de haute disponibilité qui assure la continuité de service.
- **Avantages** :
  - Haute disponibilité : réduit les interruptions de service.
  - Automatisation : la bascule se fait automatiquement sans intervention humaine.
- **Inconvénients** :
  - Complexité de configuration : nécessite une infrastructure bien pensée et redondante.
  - Coût élevé : demande souvent des ressources supplémentaires pour maintenir l'environnement de secours.
- **Savoir expliquer** : Le failover est essentiel dans les environnements critiques où le temps d'arrêt doit être minimisé. Par exemple, dans un cluster de bases de données, si le serveur principal échoue, un autre serveur prend immédiatement le relais, assurant ainsi que les services restent disponibles.

## 2\. **Primary/Replica**

- **Définition** : La réplication Primary/Replica (maître/esclave) consiste à copier les données d'un serveur principal (Primary) vers un ou plusieurs serveurs secondaires (Replica). Les Replica sont en lecture seule, tandis que le Primary gère à la fois la lecture et l'écriture.
- **Avantages** :
  - Scalabilité en lecture : permet de décharger le Primary en distribuant les requêtes de lecture sur les Replica.
  - Sauvegarde : les Replica peuvent servir de sauvegardes en temps réel.
- **Inconvénients** :
  - Pas de tolérance de panne en écriture : si le Primary échoue, les Replica ne peuvent pas écrire.
  - Latence : il peut y avoir un délai dans la synchronisation des données entre le Primary et les Replica.
- **Savoir expliquer** : Dans une architecture Primary/Replica, les données sont répliquées du Primary vers les Replica. Cette architecture est couramment utilisée pour améliorer les performances en lecture. Par exemple, un site web à fort trafic pourrait utiliser des Replica pour répondre aux requêtes des utilisateurs tout en laissant le Primary gérer les écritures.

## 3\. **Primary/Primary (Multi-Master)**

- **Définition** : La réplication Primary/Primary, aussi appelée Multi-Master, permet à plusieurs serveurs d'agir simultanément comme Primary, acceptant ainsi à la fois les lectures et les écritures.
- **Avantages** :
  - Haute disponibilité : si un Primary échoue, un autre peut continuer à gérer les opérations.
  - Tolérance de panne en écriture : permet d'éviter un point unique de défaillance pour les opérations d'écriture.
- **Inconvénients** :
  - Conflits de données : les écritures simultanées sur différents Primary peuvent entraîner des conflits.
  - Complexité : la gestion des conflits et la synchronisation des données entre les Primary augmentent la complexité de l'architecture.
- **Savoir expliquer** : La réplication Primary/Primary est utilisée dans des environnements distribués où plusieurs serveurs doivent être capables de traiter des écritures en même temps. Par exemple, dans un réseau mondial, chaque région pourrait avoir son propre serveur Primary pour minimiser la latence.

## 4\. **Réplication Synchrone et Asynchrone**

- **Définition** :
  - **Synchrone** : Les données sont répliquées en temps réel. Une opération n'est considérée comme terminée que lorsque les données sont confirmées sur tous les serveurs répliqués.
  - **Asynchrone** : Les données sont envoyées au Replica après coup, sans attendre de confirmation immédiate.
- **Avantages** :
  - **Synchrone** : garantit la cohérence des données.
  - **Asynchrone** : améliore les performances en évitant les latences dues à la synchronisation immédiate.
- **Inconvénients** :
  - **Synchrone** : peut ralentir les performances en raison de la latence.
  - **Asynchrone** : risque de perte de données en cas de panne entre les synchronisations.
- **Savoir expliquer** : Le choix entre la réplication synchrone et asynchrone dépend des exigences en termes de cohérence des données et de performances. La réplication synchrone est utilisée lorsque la cohérence est cruciale, par exemple dans les transactions financières, tandis que l'asynchrone est préférée pour des applications moins critiques où la performance prime.

## 5\. **Réplication par Journaux / par Système de Fichier**

- **Définition** :
  - **Par Journaux** : Réplication des données basée sur les journaux de transactions, où chaque modification est enregistrée et répliquée.
  - **Par Système de Fichier** : Réplication des fichiers entiers ou de blocs au niveau du système de fichiers.
- **Avantages** :
  - **Par Journaux** : offre une granularité fine pour la réplication, idéale pour les bases de données.
  - **Par Système de Fichier** : plus simple à mettre en place pour des volumes de données importants.
- **Inconvénients** :
  - **Par Journaux** : plus complexe à configurer et demande des ressources pour gérer les journaux.
  - **Par Système de Fichier** : moins flexible, car il réplique tout le système de fichiers sans distinction.
- **Savoir expliquer** : La réplication par journaux est souvent utilisée pour les bases de données, permettant de répliquer uniquement les changements. Par exemple, chaque transaction dans une base de données est enregistrée dans un journal, qui est ensuite utilisé pour répliquer ces changements sur un autre serveur. La réplication par système de fichiers est utile pour des solutions de sauvegarde globales, comme la réplication de machines virtuelles entières.

## 6\. **SQL/NoSQL**

- **Définition** :
  - **SQL** : Bases de données relationnelles utilisant le langage SQL pour gérer des structures de données en tables.
  - **NoSQL** : Bases de données non relationnelles, souvent utilisées pour des données non structurées ou semi-structurées, qui ne nécessitent pas de schéma fixe.
- **Avantages** :
  - **SQL** : forte consistance des données, standardisation, robustesse pour des transactions complexes.
  - **NoSQL** : flexibilité, scalabilité horizontale, meilleure performance pour des volumes de données très élevés.
- **Inconvénients** :
  - **SQL** : peut devenir lent et rigide avec des données massives ou non structurées.
  - **NoSQL** : moins de consistance garantie, parfois difficile à interroger sans un langage unifié comme SQL.
- **Savoir expliquer** : Les bases de données SQL sont idéales pour des applications nécessitant une intégrité transactionnelle et des relations complexes, comme un système de gestion des ressources humaines. Les bases de données NoSQL sont préférées pour des applications nécessitant une grande scalabilité, comme un site de réseaux sociaux où les données sont massivement distribuées et non structurées.
