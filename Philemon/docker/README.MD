## Contenu du Dockerfile

1. **FROM**: J'utilise comme image de base une `debian` avec le tag `:12-slim` pour une version 12 de débian et LEGERE.
2. **RUN**:
   J'exécute les commandes suivantes :
    - Met à jour les listes de paquets avec `apt-get update -y`.
    - Installe Apache avec `apt-get install --no-install-recommends apache2 -y`(cette option permet d'éviter l'
      installation de packets supplémentaires non-nécessaires).
    - Supprime les listes `apt-get` et les caches de `debconf` pour réduire la taille de l'image.
    - Nettoie les fichiers temporaires avec `apt-get clean -y`.
3. **CMD**:
    - Définit la commande par défaut pour démarrer le service Apache et ouvrir un shell `bash`:
      ```dockerfile
      CMD ["bash", "-c", "service apache2 start && exec /bin/bash"]
      ```

## Instructions

1. **Build de l'image Docker**:
   ```sh
   docker build -t apache-image .

2. **Run du conteneur**:
   ```sh
   docker run --name apache-container -p 8080:80 -it -d apache-image

- -p 8080:80 : Bind du port 8000 de ma machine (hôte) au port 80 du conteneur, permettant d'accéder au service Apache
  via `http://127.0.0.1:8080`.
- -it : mode interactif
- -d : démarre le conteneur en arriére plan.
- nom de l'image utilisée.

## Docker VS VM ?

DOCKER:
Un conteneur utilisent directement les resources du noyau de l'OS hôte.
Il permet d'empaqueter une application, un service, de manière isolée. Peut s'exécuter partout.
En général le conteneur est + legé qu'une VM.
Le conteneur est "jetables", son état n'est pas conservés.

VM:
Une Vm est une simulation d'une machine physique. Elle a aussi son propre OS qui peut être different de la machine hôte.
Elle est limitée par les resources de la machine hôte. Son état est conservée lorsqu'on éteint la VM.
Une Vm peu être longue à configurer.