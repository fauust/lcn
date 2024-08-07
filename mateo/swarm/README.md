# Déploiement automatisé de VM avec Ansible

## Présentation du projet

Ce projet est un projet de test pour la mise en place de plusieurs nodes swarm.

## Dépendances

Pour utiliser les playbooks, veuillez installer ansible sur votre machine.

Suivez le guide d'installation sur le site officiel d'ansible : [Installation d'Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

## Installation

Pour utiliser le script, veuillez suivre les instructions suivantes :

- Créer un fichier `secrets.yml` dans le répertoire `group_vars/all` avec les informations du fichier `secrets.example.yml`.

### Utilisation du script `swarm.sh`

(Attention, Si vous ne renseigné pas les informations demandées pour netdata dans ansible/groups_vars/secret.yml certaines features ne fonctionneront pas correctement)
Pour installer rapidement les machines virtuelles, veuillez utiliser la commandes suivante :

```shell
./swarm.sh
```
Le script vous demandera plusieurs informations pour la création des machines virtuelles:

- Votre nom d'utilisateur
- Votre mot de passe
- Le nom de vos machines virtuelles
- Le nombre de machines virtuelles

Voici la liste des playbooks exécutés par les scripts ci-dessus :

| Nom du playbook         | `swarm.sh` |
|-------------------------|------------|
| `setup.yml`             | X          |
| `infra_swarm.yml`       | X          |
| `platform_swarm.yml`    | X          |
| `software_swarm.yml`    | X          |

