ORG=blacktop
NAME=kibana-plugin-builder
REPO=$(ORG)/$(NAME)
# VERSION?=$(shell http https://raw.githubusercontent.com/maliceio/malice-kibana-plugin/master/package.json | jq -r '.version')
VERSION?=$(shell cat LATEST)
NODE_VERSION?=$(shell curl -s https://raw.githubusercontent.com/elastic/kibana/v$(VERSION)/.node-version)

.PHONY: all
all: build size

.PHONY: dockerfile
dockerfile: ## Update Dockerfiles
	sed -i.bu 's/ARG VERSION=.*/ARG VERSION=$(VERSION)/' Dockerfile
	sed -i.bu 's/FROM node:.*/FROM node:$(NODE_VERSION)-alpine/' Dockerfile

.PHONY: readme
readme: ## Update docker image size in README.md
	@echo "===> Fixing README.md is not implimented yet"
	# sed -i.bu 's/- Kibana [0-9.]\{5\}+/- Kibana $(VERSION)+/' README.md
	# sed -i.bu 's/v.*\/malice-.*/v$(VERSION)\/malice-$(VERSION).zip/' README.md

.PHONY: node
node: ### Build docker base image
	docker build --build-arg NODE_VERSION=${NODE_VERSION} -f Dockerfile.node -t $(ORG)/$(NAME):node .

.PHONY: build
build: dockerfile readme ## Build docker image
	docker build --build-arg VERSION=$(VERSION) -t $(ORG)/$(NAME):$(VERSION) .

.PHONY: dev
dev: base ## Build docker dev image
	docker build --squash --build-arg NODE_VERSION=${NODE_VERSION} -f Dockerfile.dev -t $(ORG)/$(NAME):$(VERSION) .

.PHONY: size
size: tags ## Update docker image size in README.md
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}GB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION))/' README.md
	sed -i.bu '/$(VERSION)/ s/[0-9.]\{3,5\}GB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION))/' README.md
	sed -i.bu '/node/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):node)/' README.md

.PHONY: tags
tags: ## Show all docker image tags
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

.PHONY: run
run: stop ## Run kibana plugin env
	@echo "===> Starting kibana elasticsearch..."
	@docker run --init -d --name kplug -p 9200:9200 -p 5601:5601 $(ORG)/$(NAME):$(VERSION)

.PHONY: ssh
ssh: ## SSH into docker image
	@docker run --init -it --rm -v `pwd`/test-plugin:/plugin/kibana-extra -w /plugin --entrypoint=sh $(ORG)/$(NAME):$(VERSION)

.PHONY: tar
tar: ## Export tar of docker image
	@docker save $(ORG)/$(NAME):$(VERSION) -o $(NAME).tar

.PHONY: elasticsearch
elasticsearch:
	@echo "===> Starting kibana elasticsearch..."
	@docker run --init -it --rm --name kplug -v `pwd`/test-plugin:/plugin/kibana-extra -p 9200:9200 -p 5601:5601 $(ORG)/$(NAME):$(VERSION) elasticsearch

.PHONY: test
test: ## Test build plugin
	@echo "===> Starting kibana tests..."
	@rm -rf test-plugin || true
	@mkdir test-plugin
	docker run --init -it --rm -v `pwd`/test-plugin:/plugin/kibana-extra -w /plugin $(ORG)/$(NAME):$(VERSION) new-plugin test

.PHONY: push
push: build size ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):node to docker hub..."
	@docker push $(ORG)/$(NAME):node
	@echo "===> Pushing $(ORG)/$(NAME):$(VERSION) to docker hub..."
	@docker push $(ORG)/$(NAME):$(VERSION)
	@docker tag $(ORG)/$(NAME):$(VERSION) $(ORG)/$(NAME):latest
	@docker push $(ORG)/$(NAME):latest

.PHONY: circle
circle: ci-size ## Get docker image size from CircleCI
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts circle-token==${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

.PHONY: clean
clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(VERSION) || true
	docker rmi $(ORG)/$(NAME):node || true
	rm -rf test-plugin || true

.PHONY: stop
stop: ## Kill running kibana-plugin docker containers
	@docker rm -f kplug || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := all
