FROM node:alpine
COPY src /app/
WORKDIR /app/
RUN alias ll='ls -l' &&  \
    ./create_tmp.sh 2>~/err.txt && \
    npm install
CMD ["npm", "run", "dev"]
