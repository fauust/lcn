FROM debian:12-slim

RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apache2 \
        bash \
        iproute2 \
        iputils-ping \
        mtr \
        telnet \
    && rm -rf /var/lib/apt/lists/* \
    /var/cache/debconf/* \
    && apt-get clean

CMD ["apache2ctl", "-D", "FOREGROUND"]