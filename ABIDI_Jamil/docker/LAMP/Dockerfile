FROM ubuntu:22.04
COPY ./install.sh /tmp/
VOLUME ["/data"]

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  && apt-get install --no-install-recommends -y \
    vim \
    wget \
  && apt-get install --no-install-recommends -y apache2 \
  && apt-get install --no-install-recommends -y mariadb-server mariadb-client \
  && apt-get install --no-install-recommends -y php phpmyadmin \
  && ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin \
  && apt-get install --no-install-recommends -y libapache2-mod-php php-mysql \
  && wget -q https://wordpress.org/latest.tar.gz \
  && tar -xvf latest.tar.gz \
  && rm -f latest.tar.gz \
  && cp -R wordpress /var/www/html/ \
  && chown -R www-data:www-data /var/www/html/wordpress/ \
  && chmod -R 755 /var/www/html/wordpress/ \
  && mkdir /var/www/html/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/ \
  # clean apt \
  && rm -rf /var/lib/apt/lists/* \
    /var/cache/debconf/* \
  && apt-get clean

CMD ["apache2ctl", "-D", "FOREGROUND"]
