FROM debian:12-slim

RUN apt-get update -y \
&& apt-get install --no-install-recommends apache2 -y \
&& rm -rf /var/lib/apt/lists/* \
  /var/cache/debconf/* \
&& apt-get clean -y

CMD ["bash", "-c", "service apache2 start && exec /bin/bash"]




