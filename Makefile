REPO=malice-plugins/kibana-malice
ORG=malice
NAME=kibana
VERSION=$(shell jq -r '.version' malice/package.json)
NODE_VERSION=$(shell cat kibana/.node-version)

all: build size test

build: ## Build docker image
	docker build -t $(ORG)/$(NAME):$(VERSION) .

base: ### Build docker base image
	docker build --build-arg NODE_VERSION=${NODE_VERSION} -f Dockerfile.base -t $(ORG)/$(NAME):base .
	docker push $(ORG)/$(NAME):base

dev: ## Build docker dev image
	docker build --build-arg NODE_VERSION=${NODE_VERSION} -f Dockerfile.dev -t $(ORG)/$(NAME):$(VERSION) .

size: ## Update docker image size in README.md
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION)| cut -d' ' -f1)-blue/' README.md

tags: ## Show all docker image tags
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

ssh: ## SSH into docker image
	@echo "===> Starting kibana elasticsearch..."
	@docker run --init -d --name ssh -v `pwd`:/home/kibana -p 9200:9200 -p 5601:5601 $(ORG)/$(NAME):$(VERSION)
	@docker exec -it ssh sh
	# @docker run --init -it --rm -v `pwd`:/home/kibana --entrypoint=sh $(ORG)/$(NAME):$(VERSION)

tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(VERSION) -o $(NAME).tar

test:
	@echo "===> Starting elasticsearch"

release: ## Create a new release
	@echo "===> Creating Release"
	git tag -a ${VERSION} -m ${MESSAGE}
	git push origin ${VERSION}

push: ## Push docker image to docker registry
	docker push $(ORG)/$(NAME):$(VERSION)

circle: ci-size ## Get docker image size from CircleCI
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(VERSION)

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY: build size tags test ssh circle
