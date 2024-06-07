#!/bin/bash

# Télécharger et exécuter le script d'installation de NVM
if wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; then
    # Recharger le profil de l'utilisateur pour charger NVM
    # shellcheck source=/dev/null
    if source ~/.bashrc; then
        # Installer la dernière version de Node.js
        nvm install node
    else
        echo "Erreur lors du chargement du profil de l'utilisateur."
        exit 1
    fi
else
    echo "Erreur lors du téléchargement ou de l'exécution du script d'installation de NVM."
    exit 1
fi
