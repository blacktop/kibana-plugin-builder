FROM malice/kibana:base

LABEL maintainer "https://github.com/blacktop"

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:/home/kibana/kibana/bin:${PATH}

RUN apk add --no-cache openjdk8-jre ca-certificates

WORKDIR /home/kibana

# Install kibana's verion of nodeJS
COPY kibana /home/kibana/kibana
RUN echo "===> Installing elasticdump" \
  && npm install elasticdump -g

WORKDIR /home/kibana/kibana
# Install kibana node_modules
RUN npm install

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
