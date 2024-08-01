FROM debian:12

RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install nodejs -yq \
    && apt-get clean -y

ADD . /app/
WORKDIR /app
RUN npm install

EXPOSE 2368
VOLUME /app/logs

CMD npm run start
