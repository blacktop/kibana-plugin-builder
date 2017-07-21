kibana-plugin-builder
=====================

[![Circle CI](https://circleci.com/gh/blacktop/kibana-plugin-builder.png?style=shield)](https://circleci.com/gh/blacktop/kibana-plugin-builder) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/kibana-plugin-builder.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder) [![Docker Image](https://img.shields.io/badge/docker%20image-727MB-blue.svg)](https://store.docker.com/community/images/blacktop/kibana-plugin-builder)

> Kibana Plugin Builder

---

### Dependencies

-	[alpine:3.6](https://hub.docker.com/_/alpine/)

### Image Tags

```bash
REPOSITORY                         TAG                 SIZE
blacktop/kibana-plugin-builder     latest              727MB
blacktop/kibana-plugin-builder     5.5.0               727MB
blacktop/kibana-plugin-builder     node                54MB
```

> **NOTE:** tag `node` is the base image that has the appropriate version of **NodeJS** for the version of **Kibana** you are using to build your plugin (it default to the version needed for latest)

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

### Use **kibana-plugin-builder** to create new plugin  

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
    "version": "5.5.0",
    "templateVersion": "7.2.0"
  }
  ...
```

```bash
$ export VERSION=$(jq -r '.version' package.json)
$ echo "===> Starting kibana elasticsearch..."
$ docker run --init -d --name kplug -v `pwd`:/plugin/my-new-plugin -p 9200:9200 -p 5601:5601 blacktop/kibana-plugin-builder:$(VERSION)
$ echo "===> Running kibana plugin..."
$ sleep 10; docker exec -it kplug bash -c "cd ../my-new-plugin && ./start.sh"
```

Build Image
-----------

To build a **kibana** dev env that uses **kibana** version `5.5.0`

```bash
$ git clone https://github.com/blacktop/kibana-plugin-builder.git
$ cd kibana-plugin-builder
$ VERSION=5.5.0 make build
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
