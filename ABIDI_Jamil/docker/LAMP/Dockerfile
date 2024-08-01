FROM ubuntu:22.04
COPY ./install.sh /tmp/
VOLUME ["/data"]
RUN bash /tmp/install.sh
CMD ["apache2ctl", "-D", "FOREGROUND"]
