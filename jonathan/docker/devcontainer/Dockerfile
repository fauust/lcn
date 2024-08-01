FROM debian:12

# Met à jour la liste des paquets et installe Git, PHP 8.0 et PHP 8.0-FPM et nettoie le cache des paquets pour réduire la taille de l'image Docker
RUN apt update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt install -y software-properties-common lsb-release ca-certificates apt-transport-https curl && \
    curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list &&\
    apt update && \
    apt install -y git php8.0 php8.0-fpm && \
    curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*