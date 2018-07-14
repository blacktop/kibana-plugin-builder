# kibana-plugin-builder

[![Circle CI](https://circleci.com/gh/blacktop/kibana-plugin-builder.png?style=shield)](https://circleci.com/gh/blacktop/kibana-plugin-builder) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Image](https://img.shields.io/badge/docker%20image-3.19GB-blue.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder)

> Kibana Plugin Builder - **kibana** plugin development environment in a **docker** image

---

### Dependencies

- [alpine:3.7](https://hub.docker.com/_/alpine/)

### Image Tags

```bash
REPOSITORY                         TAG                 SIZE
blacktop/kibana-plugin-builder     latest              3.19GB
blacktop/kibana-plugin-builder     6.3.1               3.19GB
blacktop/kibana-plugin-builder     6.1.3               1.18GB
blacktop/kibana-plugin-builder     6.0.0               1.11GB
blacktop/kibana-plugin-builder     5.6.0               1.09GB
blacktop/kibana-plugin-builder     5.5.2               1.09GB
blacktop/kibana-plugin-builder     node                686MB
```

> **NOTE:** tag `node` is the base image that has the appropriate version of **NodeJS** for the version of **Kibana** you are using to build your plugin (it defaults to the version needed for latest)

## Why?

This docker image creates a _(small as possible)_ dev environment to develop a kibana plugin in so you don't have to figure out what version of node to run or elasticsearch etc etc.

## Getting Started

### Install [template-kibana-plugin](https://github.com/elastic/template-kibana-plugin/)

```bash
$ npm install -g sao template-kibana-plugin
```

### Run the generator

```bash
$ git clone https://github.com/elastic/kibana.git
$ git checkout 6.x
$ yarn kbn bootstrap # always bootstrap when switching branches
$ node scripts/generate_plugin my_plugin_name
# generates a plugin for Kibana 6.3 in `../kibana-extra/my_plugin_name`
```

=OR=

### Use `kibana-plugin-builder` to create new plugin

```bash
$ mkdir my-new-plugin
$ cd my-new-plugin
$ docker run --init --rm -ti -v `pwd`:/plugin -w /plugin blacktop/kibana-plugin-builder node kibana/scripts/generate_plugin --help
$ docker run --init --rm -ti -v `pwd`:/plugin -w /plugin blacktop/kibana-plugin-builder node kibana/scripts/generate_plugin my-new-plugin
```

### Start Kibana Dev Environment

> **NOTE:** this assumes you have set a `version` in your `package.json`

_example:_

```json
  "kibana": {
    "version": "6.3.0",
    "templateVersion": "7.2.0"
  }
  ...
```

```bash
# Starting kibana elasticsearch...
$ docker run --init -d \
             --name kplug \
             -p 9200:9200 -p 5601:5601 \
             -v `pwd`:/plugin/my-new-plugin \
             blacktop/kibana-plugin-builder:$(jq -r '.version' package.json) elasticsearch
# Running kibana plugin...
$ docker exec -it kplug bash -c "cd ../my-new-plugin && yarn start"
```

## Build Image

To build a **kibana** dev env that uses version `6.3.0`

```bash
$ git clone https://github.com/blacktop/kibana-plugin-builder.git
$ cd kibana-plugin-builder
$ VERSION=6.3.0 make build
```

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/kibana-plugin-builder/issues/new)

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/kibana-plugin-builder/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/kibana-plugin-builder/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/kibana-plugin-builder/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2017 **blacktop**
