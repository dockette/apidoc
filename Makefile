IMAGE=dockette/apidoc
TAG=latest

.DEFAULT_GOAL := help

##@ Help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_.-]+:.*##/ { sub(/^ +/, "", $$2); printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))

##@ Docker

.PHONY: build
build: ## Build the image (TAG=latest)
	docker build -t $(IMAGE):$(TAG) .

.PHONY: run
run: ## Run the image on port 8000
	docker run --rm -p 8000:8000 $(IMAGE):$(TAG)

.PHONY: push
push: ## Push the image to Docker Hub
	docker push $(IMAGE):$(TAG)
