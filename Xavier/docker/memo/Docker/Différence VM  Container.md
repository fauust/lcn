# Différence VM / Container
| VM  | Container |
| --- | --- |
| Etat conservé | Etat non conservé : si on stoppe un container, on n'y a plus accès. Si on le remove, tous les fichiers créés dessus disparaissent ! (sauf si on crée un _**volume**_ et qu'on l'attache au container) |
| long à configurer et à démarrer | Démarrage immédiat ! |
| Installation de soft relativement facile à l'intérieur de la VM | Pas facile d'installer du soft dans le container, de toutes façons c'est pas fait pour ça. |
| Tous les deux indépendants de l'OS de la machine sur lesquels ils tournent |     |
| _**Volumes**_ |     |
| Un seul volume, qui appartient à la VM, non accessible depuis l'extérieur | Possibilité de créer un volume rémanent, extérieur au container, partageable entre plusieurs containers. |