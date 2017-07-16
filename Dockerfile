FROM alpine:3.6

LABEL maintainer "https://github.com/blacktop"

ARG VERSION=5.5.0

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:/home/kibana/kibana/bin:${PATH}

RUN apk add --no-cache openjdk8-jre nodejs-current nodejs-current-npm ca-certificates git bash

# Create kibana user
RUN adduser -S kibana -h /home/kibana -s /bin/bash -G root -u 1000 -D \
  && touch /home/kibana/.bashrc \
  && chown kibana /home/kibana/.bashrc

# Download NVM installer
ADD https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh /tmp/install.sh
RUN chown kibana /tmp/install.sh && chmod +x /tmp/install.sh

# COPY kibana /home/kibana/kibana
# RUN chown -R kibana /home/kibana/kibana

WORKDIR /home/kibana

# Install kibana's verion of nodeJS
COPY kibana /home/kibana/kibana
RUN apk add --no-cache wget \
  && echo "===> Installing NVM" \
  && su kibana bash -c '/tmp/install.sh \
    && source $HOME/.bashrc \
    && cd kibana \
    && echo "===> Installing node $(cat .node-version)" \
    && nvm install "$(cat .node-version)"; exit 0 \
    && nvm use --delete-prefix $(cat .node-version) --silent' \
  && echo "===> Installing elasticdump" \
  && npm install elasticdump -g \
  && apk del --purge wget \
  && rm -rf /tmp/*

WORKDIR /home/kibana/kibana

# Install kibana node_modules
RUN apk add --no-cache -t .build-dep python wget build-base \
  && echo "===> Installing Kibana $VERSION" \
  && su kibana bash -c 'source $HOME/.bashrc \
    && nvm use --delete-prefix $(cat .node-version) --silent \
    && npm install' \
  && apk del --purge .build-dep \
  && rm -rf /tmp/*
#
# USER kibana
#
# COPY config/kibana.dev.yml /home/kibana/kibana/config/kibana.dev.yml
# COPY entrypoint.sh /entrypoint.sh
#
# VOLUME /home/kibana/plugin
#
# EXPOSE 5601
#
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["npm", "run", "elasticsearch"]
