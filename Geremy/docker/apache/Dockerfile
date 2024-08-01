FROM ubuntu/apache2
COPY ./myapache.conf /etc/apache2/sites-available/myapache.conf

RUN apt update && apt upgrade -y
RUN a2enmod proxy && a2enmod proxy_http
RUN a2ensite myapache.conf

