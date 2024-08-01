FROM debian:12

# Définir explicitement le shell à /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Met à jour la liste des paquets et installe Git, PHP 8.0 et PHP 8.0-FPM et nettoie le cache des paquets pour réduire la taille de l'image Docker
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    source /etc/os-release && \
    apt-get install -y \
      software-properties-common \
      ca-certificates \
      apt-transport-https \
      curl && \
    curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $VERSION_CODENAME main" >/etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y git php8.0 php8.0-fpm && \
    curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*