# Dockette / Apidoc

OpenAPI documentation viewer served by Caddy with Swagger UI, Redoc, Stoplight Elements, RapiDoc and Scalar.

## Stack

- Docker image, base `debian:trixie-slim`
- Caddy web server on port 8000, Swagger UI 5.33, Redoc 2.5, Stoplight Elements 9.0, RapiDoc 9.3, Scalar 1.72
- Published to Docker Hub as `dockette/apidoc` for linux/amd64 and linux/arm64 by GitHub Actions

## Development

```bash
make build       # build the image
make run         # run it locally on http://localhost:8000
```

There is no `test` target: build the image and open http://localhost:8000 to check every viewer loads.

## Principles

- KISS: one image does one job; no extra services or tools.
- DRY: shared steps live in the base image, not copied into every Dockerfile.
- YAGNI: add a package only when the image needs it.
- Pin versions, keep layers small, clean package caches in the same `RUN`.
- Every change is built with `make build` and checked with `make run` before a commit.
