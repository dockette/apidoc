IMAGE=dockette/apidoc
TAG=latest
VERSION:=$(shell cat VERSION)

build:
	docker build -t $(IMAGE):$(TAG) .

run:
	docker run --rm -p 8000:8000 $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)

.PHONY: version
version:
	@echo ${VERSION}

.PHONY: release
release:
	@date -u +%Y.%m.%d > VERSION
	@echo "VERSION: ${VERSION} -> $$(cat VERSION)"
	@echo "next: git commit -am \"Release: $$(cat VERSION)\" && git push"
