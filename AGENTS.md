# Dockette / Apidoc

Instructions for AI coding agents working in this repository.

## Overview

`dockette/apidoc` is a service image (see IMAGES.md) that serves five OpenAPI viewers and a landing page with Caddy
on port `8000`. It bundles the viewer assets at build time and ships our own HTML pages from `html/`. It holds no
API spec of its own and has no backend: every viewer reads the spec URL from the `?url=` query parameter in the
browser.

- **Image**: `dockette/apidoc`, one tag `latest`
- **Base**: `debian:trixie-slim` (official image, not `dockette/debian`), Caddy from the Cloudsmith apt repository
- **Viewers**: Swagger UI, Redoc, Stoplight Elements, RapiDoc, Scalar, pinned by `*_VERSION` in the `Dockerfile`
- **Platforms**: `linux/amd64`, `linux/arm64`

## Documentation

- `PRD.md` says what the image is for and what it will not do. Read it before adding a viewer or a feature.
- `TECH.md` explains the build steps, the Caddy config and the known limits. Read it before changing
  `Dockerfile` or `Caddyfile`.
- `DESIGN.md` describes the landing page and how each viewer page is wired. Read it before changing `html/`.
- `README.md` is also the Docker Hub description; CI publishes it from `master`.
- Organization rules are in [dockette/dockette specs](https://github.com/dockette/dockette/tree/master/specs).

## Commands

The `Makefile` has `build`, `run` and `push` only; there is no `make test` and no `make help`. To build, run on
port `8000` and check every page the way CI does:

```bash
make build
make run

# In a second shell, while `make run` is up
for p in / /swagger/ /redoc/ /elements/ /rapidoc/ /scalar/; do curl -sf http://localhost:8000$p > /dev/null && echo "OK $p"; done
```

CI does not call `make`. The `test` job builds `dockette/apidoc:latest-test` with `docker/build-push-action`,
starts it and runs `curl -sf` against the six paths above. The `build` job then calls the reusable workflow for
both platforms and pushes from `master` only.

## Conventions

- One viewer is one folder in `html/{viewer}/` with an `index.html`, one download step in the `Dockerfile` into
  `/srv/www/{viewer}/`, one button and one card in `html/index.html`, one curl step in the workflow and one block
  in the README.
- Every viewer page reads `?url=` with `URLSearchParams` and falls back to the Petstore spec
  `https://petstore3.swagger.io/api/v3/openapi.json`. Keep that contract; the landing page and the README rely on it.
- Viewer versions live in `ENV *_VERSION` lines at the top of the `Dockerfile`. A bump changes only that line.

## Traps

- **`COPY html/ /srv/www/` runs after the downloads.** A file in `html/{viewer}/` overwrites the upstream file of
  the same name, which is how `html/swagger/index.html` replaces the Swagger UI `dist` page.
- **The Swagger step deletes `index.html` and `swagger-initializer.js` from `dist`.** Our page loads
  `swagger-ui-bundle.js`, `swagger-ui-standalone-preset.js` and `swagger-ui.css` by relative path; a Swagger UI
  release that renames them breaks the page, and the CI curl check still passes.
- **The CI checks only HTTP 200 for each `index.html`.** They don't prove a viewer renders. After a version bump,
  open each viewer with the Petstore spec in a browser.
- **Each asset URL has its own layout.** Redoc comes from `cdn.redoc.ly`, Elements and RapiDoc from `unpkg.com`,
  Scalar from `cdn.jsdelivr.net`. Check the file path exists for the new version before bumping.
- **The spec is fetched by the browser, not by Caddy.** A spec on another host needs CORS on that host; the
  `Access-Control-Allow-Origin *` header in `Caddyfile` only covers files served from this container.
- **Caddy is not pinned.** `apt install -y caddy` takes the current stable release on every weekly rebuild.
- **`latest` is the only tag.** Every merge to `master` and every Monday rebuild overwrites it.
- **`.dockerignore` does not exclude `*.md`.** It doesn't matter today because the `Dockerfile` copies only
  `html/` and `Caddyfile`; keep it that way or extend `.dockerignore`.
- Usage for image users (port, spec URLs, mounting a local spec) lives in `README.md`, not here.

## Ground Rules

- The container runs as root; there is no `USER` and no `HEALTHCHECK` in the `Dockerfile`.
- Caddy listens on plain HTTP `:8000` (`Caddyfile`). There is no TLS and no authentication; put a proxy in front
  for anything beyond local or internal use.
- No secrets exist in this image. Never add tokens or private spec URLs to `html/` or the `Dockerfile`.
