FROM blacktop/kibana-plugin-builder:node

LABEL maintainer "https://github.com/blacktop"

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:/plugin/kibana/bin:${PATH}

ARG VERSION=6.3.1

COPY node-prune.sh /usr/bin/node-prune
RUN echo "===> Installing elasticdump" \
  && set -ex \
  && yarn global add elasticdump \
  && cd /usr/local/lib/ && node-prune || true

WORKDIR /plugin

RUN echo "===> Cloning Kibana v$VERSION" \
  && git clone --depth 1 -b v${VERSION} https://github.com/elastic/kibana.git

WORKDIR /plugin/kibana

# Install kibana node_modules
RUN set -ex \
  && yarn kbn bootstrap \
  && cd /usr/local/lib \
  && node-prune || true \
  && chown -R node:node /plugin

COPY entrypoint.sh /entrypoint.sh
RUN chown node:node /entrypoint.sh

USER node

EXPOSE 5601 9200

ENTRYPOINT ["/entrypoint.sh"]
