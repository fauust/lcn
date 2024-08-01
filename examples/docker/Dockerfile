FROM debian:12-slim

RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      bash \
      iperf \
      iproute2 \
      mtr \
      telnet \
    # clean apt \
    && rm -rf /var/lib/apt/lists/* \
      /var/cache/debconf/* \
    && apt-get clean

CMD ["/usr/bin/bash"]
