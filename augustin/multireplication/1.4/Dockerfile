FROM mariadb:11.4

RUN apt-get update -y && apt-get install -y chrony --no-install-recommends
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN service chrony start
# RUN timedatectl set-timezone Africa/Nairobi --adjust-system-clock
# RUN timedatectl set-ntp yes
