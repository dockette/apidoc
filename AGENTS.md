# AGENTS.md

## Project

Dockette Apidoc builds `dockette/apidoc`, a self-contained OpenAPI documentation viewer image. It serves Swagger UI, Redoc, Stoplight Elements, RapiDoc, Scalar, and the landing page from bundled local assets through Caddy on port `8000`.

## Images

- Default image: `dockette/apidoc:latest`.
- Build context: repository root `.` with `Dockerfile`, `html/`, and `Caddyfile`.
- Base image: `debian:bookworm-slim`.
- Viewer versions are pinned with `ENV` values in `Dockerfile`; update README, screenshots/docs, and tests when changing served viewers or routes.
- GitHub Actions builds `linux/amd64` for tests, then publishes `linux/amd64,linux/arm64` through the shared Dockette Docker workflow on `master` and the weekly schedule.

## Commands

- `make build` builds `${DOCKER_IMAGE}:${DOCKER_TAG}` from `.`.
- `make test` builds the image, starts a temporary container on `${DOCKER_TEST_PORT:-8000}`, and curls `/`, `/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/`, and `/scalar/`.
- `make run` starts the image locally on `8000:8000`.
- `make push` pushes the current tag.

## Testing Notes

- Prefer `make test` after Dockerfile, `html/`, or `Caddyfile` changes.
- Use `make -n build test run` to dry-run command wiring without requiring Docker.
- The smoke test requires Docker, `curl`, and a free host port matching `DOCKER_TEST_PORT`.

## Guidelines

- Keep `Dockerfile`, `Makefile`, README, Caddy routes, `html/` viewer pages, and `.github/workflows/docker.yml` aligned.
- Prefer `DOCKER_*` names for Docker-related Makefile variables.
- Place `.PHONY: <target>` directly above each Makefile target.
- Keep README badges and maintenance sections consistent with other Dockette image repos.
- Do not add CDN runtime dependencies; the README promises bundled local assets.
- Do not introduce unrelated formatting or structural changes.
