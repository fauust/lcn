# Conteneur vs Machine Virtuelle

## Conteneur

Avantages :

- Plus léger au niveau de la mémoire et de stockage
- Ils sont isolés de l'hôte, donc plus sécurisé
- Démarrage rapide

Inconvénients :

- Compatibilité limitée avec les OS
- Gestion complexe

Réseaux virtuels :

- Réseaux internes et externes :

Les conteneurs peuvent être connectés à différents réseaux virtuels pour contrôler l'accessibilité et la sécurité.
Par exemple, un réseau interne pour la communication entre conteneurs et un réseau externe pour l'accès depuis l'extérieur.

- Isolation réseau :

Les réseaux virtuels permettent une isolation réseau efficace, ce qui empêche les conteneurs  de communiquer avec des ressources non autorisées et limite les risques de sécurité.

## Machine Virtuelle

Avantages :

- Isolation complète des systèmes d'exploitation
- Gestion plus facile

Inconvénients :

- Démarrage plus long
- Taille plus importante

Réseaux Virtuels :

- Réseaux personnalisés :

Les machines virtuelles peuvent être connectées à des réseaux virtuels qui simulent des environnements réseau physiques, avec des configurations complexes de routage, de sous-réseaux et de sécurité.

- Isolation réseau :

Comme pour les conteneurs, les réseaux virtuels permettent d'isoler les machines virtuelles, mais avec une flexibilité accrue pour simuler des topologies réseau complexes et des configurations de sécurité avancées.
