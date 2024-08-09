FROM wordpress:6.5

# Installation des dépendances nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sudo \
    gnupg \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copier le script d'installation de WordPress
COPY install-wordpress.sh /usr/local/bin/install-wordpress.sh
RUN chmod +x /usr/local/bin/install-wordpress.sh

# Exécution du script d'installation de WordPress
ENTRYPOINT ["/usr/local/bin/install-wordpress.sh"]
