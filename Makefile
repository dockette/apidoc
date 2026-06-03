DOCKER_IMAGE=dockette/apidoc
DOCKER_TAG?=latest
DOCKER_TEST_PORT?=8000

.PHONY: build test run push

build:
	docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

test: build
	@set -eu; \
	container="apidoc-test-$$(date +%s)"; \
	trap 'docker rm -f "$$container" >/dev/null 2>&1 || true' EXIT; \
	docker run --rm -d --name "$$container" -p ${DOCKER_TEST_PORT}:8000 ${DOCKER_IMAGE}:${DOCKER_TAG} >/dev/null; \
	for i in $$(seq 1 30); do \
		if curl -sf "http://localhost:${DOCKER_TEST_PORT}/" >/dev/null; then \
			break; \
		fi; \
		if [ "$$i" -eq 30 ]; then \
			echo "Landing page failed"; \
			exit 1; \
		fi; \
		sleep 1; \
	done; \
	for endpoint in / /swagger/ /redoc/ /elements/ /rapidoc/ /scalar/; do \
		curl -sf "http://localhost:${DOCKER_TEST_PORT}$$endpoint" >/dev/null; \
		echo "$$endpoint OK"; \
	done

run:
	docker run --rm -p 8000:8000 ${DOCKER_IMAGE}:${DOCKER_TAG}

push:
	docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
