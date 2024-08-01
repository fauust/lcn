FROM wordpress:latest

# Installer wget et nano
RUN apt-get update && apt-get install -y wget nano default-mysql-client \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
# Copier le script d'installation de WordPress
COPY install-wordpress.sh /install-wordpress.sh
RUN chmod +x /install-wordpress.sh

# Exécuter le script d'installation
CMD ["sh", "/install-wordpress.sh"]
