FROM mariadb:11.4

# Install cron and create necessary directories
RUN apt-get update && apt-get install -y cron && \
    mkdir -p /var/log/cron

# Copy the backup script and set permissions
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Copy the crontab file and set up cron
COPY crontab.txt /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

# Default command to run cron
CMD ["cron", "-f"]
CMD ["service cron start"]
