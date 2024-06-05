#!/bin/bash

# Variables
USER="mateo-nicoud"
HOST="192.168.122.240"
KEY_PATH="/home/mateo-nicoud/.ssh/vb"
PASSWORD="password"

export SSHPASS="$PASSWORD"
# Supprimer l'entrée du host dans le fichier known_hosts
ssh-keygen -f "/home/mateo-nicoud/.ssh/known_hosts" -R "$HOST"
chown mateo-nicoud:mateo-nicoud /home/mateo-nicoud/.ssh/known_hosts

# Authentication SSH
sshpass -e ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no "$USER@$HOST"
