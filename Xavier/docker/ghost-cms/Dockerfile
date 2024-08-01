FROM debian:12

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install nodejs -yq \
    && apt-get clean -y

COPY . /app/
WORKDIR /app
RUN npm install

EXPOSE 2368
VOLUME /app/logs

CMD ["npm", "run", "start"]
