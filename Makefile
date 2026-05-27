IMAGE=dockette/apidoc
TAG=latest
TEST_PORT=8000

.PHONY: build test run push

build:
	docker build -t $(IMAGE):$(TAG) .

test: build
	@set -eu; \
	container="apidoc-test-$$(date +%s)"; \
	trap 'docker rm -f "$$container" >/dev/null 2>&1 || true' EXIT; \
	docker run --rm -d --name "$$container" -p $(TEST_PORT):8000 $(IMAGE):$(TAG) >/dev/null; \
	for i in $$(seq 1 30); do \
		if curl -sf "http://localhost:$(TEST_PORT)/" >/dev/null; then \
			break; \
		fi; \
		if [ "$$i" -eq 30 ]; then \
			echo "Landing page failed"; \
			exit 1; \
		fi; \
		sleep 1; \
	done; \
	for endpoint in / /swagger/ /redoc/ /elements/ /rapidoc/ /scalar/; do \
		curl -sf "http://localhost:$(TEST_PORT)$$endpoint" >/dev/null; \
		echo "$$endpoint OK"; \
	done

run:
	docker run --rm -p 8000:8000 $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)
