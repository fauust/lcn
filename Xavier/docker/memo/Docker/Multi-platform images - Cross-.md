# Multi-platform images - Cross-compilation
Documentation
-------------

[https://docs.docker.com/build/building/multi-platform/](https://docs.docker.com/build/building/multi-platform/) 

Exemple de cross-compilation
----------------------------

[https://docs.docker.com/build/building/multi-platform/#cross-compilation](https://docs.docker.com/build/building/multi-platform/#cross-compilation) 

L'outil de cross-compilation = `buildx`

On spécifie :

*   BUILD\_PLATFORM
*   ds

```text-x-dockerfile
docker buildx build --platform linux/amd64,... -t <image_name:tag> --push
```

Puis on lance ;

```text-x-dockerfile
docker run -ti --rm docker.io/fheslouin/multiarch:latest uname -m
```