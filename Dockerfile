FROM blacktop/kibana-plugin-builder:node

LABEL maintainer "https://github.com/blacktop"

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:/plugin/kibana/bin:${PATH}

RUN apk add --no-cache openjdk8-jre ca-certificates git bash

ARG VERSION=5.5.0

RUN echo "===> Installing elasticdump" \
  && npm install elasticdump -g

WORKDIR /plugin

RUN echo "===> Cloning Kibana v$VERSION" \
    && git clone --depth 1 -b v${VERSION} https://github.com/elastic/kibana.git

WORKDIR /plugin/kibana

# Install kibana node_modules
RUN npm install

RUN chown -R node: /plugin

EXPOSE 5601 9200

USER node

CMD ["npm", "run", "elasticsearch"]
