FROM mariadb:11.4

RUN apt-get update \
    && apt-get install -y \
    netcat-openbsd \
    restic \
    mariadb-backup \
    # openssh-client \
    # openssh-server \
    --no-install-recommends \
    # && service ssh start \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /data \
    && mkdir /data/backup_restic \
    && touch /data/mariadb-backup.log
