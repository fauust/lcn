FROM ubuntu/apache2:2.4-22.04_edge
LABEL version="0.1" \
      description="This image is used to build an apache container with specific configuration"
COPY ./myapache.conf /etc/apache2/sites-available/myapache.conf
RUN apt-get update && apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
RUN a2enmod proxy \
    a2enmod proxy_http \
    a2ensite myapache.conf

