#!/bin/bash

set -e  # Arrêter le script en cas d'erreur

# Arrêter tous les conteneurs en cours d'exécution
if [ "$(docker ps -q)" ]; then
    echo "Arrêt de tous les conteneurs..."
    docker stop "$(docker ps -q)"
else
    echo "Aucun conteneur en cours d'exécution."
fi

# Supprimer tous les conteneurs (arrêtés)
if [ "$(docker ps -a -q)" ]; then
    echo "Suppression de tous les conteneurs..."
    docker rm -f "$(docker ps -a -q)"
else
    echo "Aucun conteneur arrêté à supprimer."
fi

# Supprimer toutes les images Docker
if [ "$(docker images -q)" ]; then
    echo "Suppression de toutes les images Docker..."
    docker rmi -f "$(docker images -q)"
else
    echo "Aucune image Docker à supprimer."
fi

# Supprimer tous les volumes Docker
if [ "$(docker volume ls -q)" ]; then
    echo "Suppression de tous les volumes Docker..."
    docker volume rm "$(docker volume ls -q)"
else
    echo "Aucun volume Docker à supprimer."
fi

# Supprimer tous les réseaux Docker, sauf les réseaux par défaut
networks_to_remove=$(docker network ls -q | grep -vE "bridge|host|none")

if [ -n "$networks_to_remove" ]; then
    echo "Suppression de tous les réseaux Docker, sauf les réseaux par défaut..."
    # Utilisation de xargs pour éviter la séparation des mots
    echo "$networks_to_remove" | xargs docker network rm
else
    echo "Aucun réseau Docker à supprimer."
fi

# Nettoyer les ressources inutilisées
echo "Nettoyage des ressources inutilisées..."
docker system prune -af --volumes

echo "Nettoyage Docker terminé."
