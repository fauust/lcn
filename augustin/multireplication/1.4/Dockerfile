FROM mariadb:11.4

RUN apt-get update -y && apt-get install -y chrony --no-install-recommends &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# RUN timedatectl set-timezone Africa/Nairobi --adjust-system-clock
# RUN timedatectl set-ntp yes

CMD ["service chrony start"]