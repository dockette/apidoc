IMAGE=dockette/apidoc
TAG=latest

build:
	docker build -t $(IMAGE):$(TAG) .

run:
	docker run --rm -p 8000:8000 $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)
