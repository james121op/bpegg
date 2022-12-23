FROM debian:stable-slim

LABEL James121op, <me@james121op.me>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    #install dependencies
    && apt-get dist-upgrade -y \
    && apt-get -y install curl ca-certificates tar jq pip \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && pip install --no-cache-dir gdown  \
    #misc
    && useradd -d /home/container -m container \
    && rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
