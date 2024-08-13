FROM mariadb:11.4

RUN apt-get update && apt-get install -y cron && \
    mkdir -p /var/log/cron && \
    touch /var/log/cron/backup.log  && \
    chmod 777 -R /var/log

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

COPY crontab.txt /etc/cron.d/backup-cron
RUN chmod 644 /etc/cron.d/crontab && crontab /etc/cron.d/backup-cron

COPY start_cron.sh /usr/local/bin/start_cron.sh
RUN chmod +x /usr/local/bin/start_cron.sh

CMD ["/usr/local/bin/start_cron.sh"]
