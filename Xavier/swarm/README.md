# swarm
An example of Docker swarm deployment of a Wordpress app in a swarm of 3 VMs

Tuto :

[https://docs.docker.com/engine/swarm/swarm-tutorial/](https://docs.docker.com/engine/swarm/swarm-tutorial/)

Préalable
---------

### Créer 3 VM

avec Libvirt, par exemple. Chaque VM a un disque de 10G, 1 CPU, 2G de RAM. (total 6G)

See ansible playbook `build_vm.yml`

Pour les créer : `ansible-playbook build_vm.yml`

```text-x-yaml
---
- name: Create Debian VMs using build_vm role
  hosts: localhost
  become: true
  roles:
    - role: build_vm
      vars:
        vm_name: swarm_master
    - role: build_vm
      vars:
        vm_name: swarm_worker1
    - role: build_vm
      vars:
        vm_name: swarm_worker2
```

*   Pour voir la liste des VMs : `virsh list --all`
*   Pour les démarrer :  
    *   `virsh` `list --all` `|` `awk` `'/swarm_/ { system("virsh start " $2) }'`
*   Pour voir leurs adresses IP :
    *   `virsh` `list --all` `|` `awk` `'/swarm_/ { system("virsh domifaddr " $2) }'`

| VM  | IP  | Role |
| --- | --- | --- |
| swarm\_master | 192.168.122.118 | Manager |
| swarm\_worker1 | 192.168.122.144 | Worker 1 |
| swarm\_worker2 | 192.168.122.161 | Worker 2 |

### Installer Docker-CE sur chacune des VM :

https://docs.docker.com/engine/install/debian/

Création du manager
-------------------

Se connecter en SSH sur la VM “master”  : dans l'exemple :

*   `ssh root@192.168.122.118`
*   Mais comme notre role `build_vm` a automatiquement créé une entrée dans `~/.ssh/config`, on peut taper directement :

    `ssh swarm_master`


```text-plain
docker swarm init --advertise-addr 192.168.122.118
```

*   Création du noeud master
*   \--advertise-addr= Indique

**La commande "docker:**

```text-plain
Swarm initialized: current node (k8sazu7e8asrwm4gx4el65c41) is now a manager.

To add a worker to this swarm, run the following command:

docker swarm join --token SWMTKN-1-624nkq3... 192.168.122.118:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Création d'un worker
--------------------

A l'intérieur d'une VM worker :

```text-plain
docker swarm join --token SWMTKN-1-624nkq3... 192.168.122.118:2377
```

**Réponse :**

```text-plain
This node joined a swarm as a worker.
```

Lancement d'un service
----------------------

```text-plain
docker service create --replicas 1 --name helloworld alpine ping docker.com
```

Connaître les services en cours
-------------------------------

```text-plain
$> docker service ls

ID             NAME         MODE         REPLICAS   IMAGE           PORTS
rnyeukw4pu26   helloworld   replicated   1/1        alpine:latest
```

Effacer un service
------------------

```text-plain
docker service rm helloworld

helloworld
```

Déployer des services depuis un stack.yml (équivalent docker-compose.yml)
-------------------------------------------------------------------------

Avec Docker Swarm, les fichiers `stack.yaml` jouent un rôle central. Ces fichiers ressemblent beaucoup aux fichiers `docker-compose.yml` utilisés dans Docker Compose - La principale différence réside dans leur utilisation.

*   Docker Compose est principalement utilisé pour **définir et exécuter des applications multi-conteneurs sur un seul hôte**. Il est idéal pour le développement, les tests et les environnements de production de petite taille.
*   En revanche, les fichiers `stack.yaml` sont utilisés avec Docker Swarm, qui est conçu pour **l'orchestration de conteneurs sur plusieurs hôtes**, offrant une haute disponibilité et une meilleure montée en charge.
*   Dans Docker Swarm, les fichiers `stack.yaml` peuvent inclure des spécificités qui ne sont pas présentes ou nécessaires dans Docker Compose. Par exemple, dans Swarm, vous pouvez spécifier des paramètres de déploiement pour vos services, tels que le nombre de réplicas, les contraintes de déploiement sur certains nœuds, ou les politiques de mise à jour.

**Exemple de Spécification de Déploiement** :

```text-x-yaml
services:
  mon_service:
    image: mon_image
    deploy:
      replicas: 5
      update_config:
        parallelism: 2
        delay: 10s
```

Dans cet exemple, le service `mon_service` est configuré pour avoir 5 réplicas, avec une politique de mise à jour spécifiant comment les mises à jour doivent être déployées.

Un point important est que les fichiers `docker-compose.yml` peuvent souvent être utilisés directement ou avec peu de modifications dans Docker Swarm. Cependant, pour tirer pleinement parti des fonctionnalités avancées de Swarm, il est recommandé d'adapter et d'optimiser les fichiers pour ce dernier.

### Exemple très simple pour le service mariadb

On rajoute juste la spec `node.role == worker` pour dire à Docker swarm que ce service doit être lancé sur un worker du swarm.

```text-x-yaml
services:

  mariadb:
    # The docker deployment instructions
    deploy:
      placement:
        constraints:
          - node.role == worker
    # The container specifications
    container_name: mydb
    image: mariadb:11.4
```

Pour déployer les services sur les VMs :

1.  Copier le fichier `docker-compose-stack.yml` sur le manager (scp …)
2.  **Depuis le manager (ssh)** : taper la commande :

```text-plain
docker stack deploy -c docker-compose-stack.yml wp_stack
```

*   wp\_stack : le nom de la stack

Firewall
--------

Si on a démarré le firewall, puis éteint, il faut relancer le daemon `docker` pour qu'il ne prenne plus en compte le firewall :

```text-plain
sudo nft list ruleset
sudo systemctl restart docker.service
sudo nft list ruleset
sudo docker compose up -d
```
