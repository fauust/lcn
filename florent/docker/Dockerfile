FROM debian:12-slim

# Install Apache & PHP + std utilities
RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apache2 \
        bash \
        iproute2 \
        iputils-ping \
        mtr \
        php \
        php-cli \
        php-fpm \
        telnet \
    && rm -rf /var/lib/apt/lists/* \
    /var/cache/debconf/* \
    && php -v \
    && apt-get clean

# Config Apache
RUN a2enmod php8.2 \
    && a2enmod rewrite \
    && a2dissite 000-default \
    && cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/apache.conf \
    && sed -i 's|/var/www/html|/var/www/sebflo|g' /etc/apache2/sites-available/apache.conf \
    && a2ensite apache.conf

# Config PHP
RUN mkdir -p /var/www/sebflo \
    && echo '<?php phpinfo(); ?>' > /var/www/sebflo/phpinfo.php \
    && echo '<?php echo "Hello, World!"; ?>' > /var/www/sebflo/index.php

CMD ["apache2ctl", "-D", "FOREGROUND"]