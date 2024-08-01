FROM debian:12

# Install apache2 and php extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2  \
    curl  \
    ca-certificates \
    libapache2-mod-php \
    php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Wordpress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress && \
    rm latest.tar.gz && \
    rm /var/www/html/index.html

# Enable apache mods
RUN a2enmod rewrite

# Set apache2 configuration
COPY wordpress.conf /etc/apache2/sites-available/wordpress.conf
RUN a2ensite wordpress.conf && \
    a2dissite 000-default.conf

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

