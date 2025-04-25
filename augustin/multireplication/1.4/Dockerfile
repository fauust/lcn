FROM mariadb:11.4

RUN apt-get update && apt-get install -y netcat-openbsd --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install chrony without trying to start it
#RUN apt-get update && \
#    DEBIAN_FRONTEND=noninteractive apt-get install -y chrony --no-install-recommends && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
#CMD ["mysqld"]
