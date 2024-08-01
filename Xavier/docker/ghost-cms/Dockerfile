FROM debian:12

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl=8.9.1 gnupg=2.4.5 -yq \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install --no-install-recommends nodejs=20.16.0 -yq \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app
RUN npm install

EXPOSE 2368
VOLUME /app/logs

CMD ["npm", "run", "start"]
