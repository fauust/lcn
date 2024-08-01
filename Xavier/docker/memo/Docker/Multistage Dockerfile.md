# Dockerfile multistage
Doc officielle
--------------

[https://docs.docker.com/build/building/multi-stage/#use-multi-stage-builds](https://docs.docker.com/build/building/multi-stage/#use-multi-stage-builds) 

Essai 1 : avec une seule image FROM Golang
------------------------------------------

Dockerfile :

```text-x-dockerfile
FROM golang:1.22

WORKDIR /usr/src/app

COPY . .

# Compile code
ENV GO111MODULE off
RUN go build -v -o /usr/local/bin/server ./

CMD ["server"]
```

Build :

```text-x-dockerfile
docker build -t goapp .
```

Size : _**895 MB**_

```text-x-dockerfile
❯ docker images
REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
goapp                    latest    4e10be9409f0   29 minutes ago   895MB
```

Essai 2 : multistage
--------------------

Dockerfile :

```text-x-dockerfile
####### STAGE 1 : build
FROM golang:1.22 as build

WORKDIR /usr/src/app

COPY . .

# Compile code
ENV GO111MODULE off
# RUN go build -v -o /usr/local/bin/server ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /usr/local/bin/server ./


####### STAGE 2 : create image with only the binary
FROM scratch
COPY --from=build /usr/local/bin/server /usr/local/bin/server 
CMD ["server"]
```

Build :

```text-x-dockerfile
docker build -t goapp .
```

Size : _**7 MB**_

```text-x-dockerfile
❯ docker images
REPOSITORY               TAG       IMAGE ID       CREATED              SIZE
goapp                    latest    5f60dcbc1af3   About a minute ago   7MB
```