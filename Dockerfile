FROM blacktop/kibana-plugin-builder:node

LABEL maintainer "https://github.com/blacktop"

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:/plugin/kibana/bin:${PATH}

RUN apk add --no-cache openjdk8-jre ca-certificates git bash

ARG VERSION=6.1.3

COPY node-prune.sh /usr/bin/node-prune
RUN echo "===> Installing elasticdump" \
  && npm install sao template-kibana-plugin elasticdump -g \
  && cd /usr/local/lib/ && node-prune || true

WORKDIR /plugin

RUN echo "===> Cloning Kibana v$VERSION" \
    && git clone --depth 1 -b v${VERSION} https://github.com/elastic/kibana.git

WORKDIR /plugin/kibana

# Install kibana node_modules
RUN npm install

COPY entrypoint.sh /entrypoint.sh
RUN chown -R node: /plugin \
  && chmod +x /entrypoint.sh \
  && chown -R node: /entrypoint.sh

USER node

EXPOSE 5601 9200

ENTRYPOINT ["/entrypoint.sh"]
