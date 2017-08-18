kibana-plugin-builder
=====================

[![Circle CI](https://circleci.com/gh/blacktop/kibana-plugin-builder.png?style=shield)](https://circleci.com/gh/blacktop/kibana-plugin-builder) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Image](https://img.shields.io/badge/docker%20image-1.09GB-blue.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder)

> Kibana Plugin Builder - **kibana** plugin development environment in a **docker** image

---

### Dependencies

-	[alpine:3.6](https://hub.docker.com/_/alpine/)

### Image Tags

```bash
REPOSITORY                         TAG                 SIZE
blacktop/kibana-plugin-builder     latest              1.09GB
blacktop/kibana-plugin-builder     5.5.2               1.09GB
blacktop/kibana-plugin-builder     node                54MB
```

> **NOTE:** tag `node` is the base image that has the appropriate version of **NodeJS** for the version of **Kibana** you are using to build your plugin (it defaults to the version needed for latest)

Getting Started
---------------

### Install [template-kibana-plugin](https://github.com/elastic/template-kibana-plugin/)

```bash
$ npm install -g sao template-kibana-plugin
```

### Run the generator

```bash
$ cd my-new-plugin
$ sao kibana-plugin
```

=OR=

### Use `kibana-plugin-builder` to create new plugin  

```bash
$ mkdir my-new-plugin
$ cd my-new-plugin
$ docker run --init --rm -ti -v `pwd`:/plugin -w /plugin blacktop/kibana-plugin-builder new-plugin
```

### Start Kibana Dev Environment

> **NOTE:** this assumes you have set a `version` in your `package.json`

*example:*

```json
  "kibana": {
    "version": "5.5.2",
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
$ docker exec -it kplug bash -c "cd ../my-new-plugin && npm start"
```

Build Image
-----------

To build a **kibana** dev env that uses version `5.5.2`

```bash
$ git clone https://github.com/blacktop/kibana-plugin-builder.git
$ cd kibana-plugin-builder
$ VERSION=5.5.2 make build
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
