FROM wordpress:6.5

# Installer wget, nano et le client MySQL
RUN apt-get update && apt-get install -y wget nano default-mysql-client --no-install-recommends \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
# Copier le script d'installation de WordPress
COPY install-wordpress.sh /install-wordpress.sh
RUN chmod +x /install-wordpress.sh

# Exécuter le script d'installation
CMD ["sh", "/install-wordpress.sh"]