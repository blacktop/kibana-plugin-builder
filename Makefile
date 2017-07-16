REPO=malice-plugins/kibana-malice
ORG=malice
NAME=kibana
# VERSION=$(shell jq -r '.version' malice/package.json)
VERSION=5.5.0

all: build size test

build:
	docker build -t $(ORG)/$(NAME):$(VERSION) .

base:
	docker build -f Dockerfile.base -t $(ORG)/$(NAME):base .

dev:
	docker build --build-arg -f Dockerfile.dev -t $(ORG)/$(NAME):$(VERSION) .

size:
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION)| cut -d' ' -f1)-blue/' README.md

tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

ssh:
	@docker run --init -it --rm -v `pwd`:/home/kibana --entrypoint=sh $(ORG)/$(NAME):$(VERSION)

tar:
	docker save $(ORG)/$(NAME):$(VERSION) -o $(NAME).tar

test:
	@echo "===> Starting elasticsearch"

release: ## Create a new release
	@echo "===> Creating Release"
	git tag -a ${VERSION} -m ${MESSAGE}
	git push origin ${VERSION}

circle: ci-size
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

clean:
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(VERSION)

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY: build size tags test ssh circle
