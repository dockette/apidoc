# Apidoc Tech

One Caddy process serves static files from `/srv/www`: our HTML pages and the downloaded viewer bundles.

## Architecture

```
build:  debian:trixie-slim -> apt: curl, wget, unzip, ca-certificates
                           -> apt (Cloudsmith repo): caddy
                           -> downloads: swagger-ui dist, redoc.js, elements.js/css, rapidoc.js, scalar.js
                           -> COPY html/ /srv/www/, COPY Caddyfile /etc/caddy/Caddyfile
run:    caddy run --config /etc/caddy/Caddyfile  (PID 1, :8000, file_server on /srv/www)
```

- One process, no entrypoint script, no environment variables read at start.
- No backend: the browser fetches the spec from the `?url=` value, and the viewer renders it client side.

## Stack

- Base: `debian:trixie-slim` (official image).
- Caddy: current stable from `https://dl.cloudsmith.io/public/caddy/stable/`, not pinned.
- Swagger UI `5.33.0` (`SWAGGER_UI_VERSION`), GitHub release tarball, `dist/` folder.
- Redoc `2.5.4` (`REDOC_VERSION`), `redoc.standalone.js` from `cdn.redoc.ly`.
- Stoplight Elements `9.0.25` (`STOPLIGHT_ELEMENTS_VERSION`), `web-components.min.js` and `styles.min.css` from
  `unpkg.com`.
- RapiDoc `9.3.8` (`RAPIDOC_VERSION`), `rapidoc-min.js` from `unpkg.com`.
- Scalar `1.72.1` (`SCALAR_VERSION`), `@scalar/api-reference` `standalone.js` from `cdn.jsdelivr.net`.

## Layout

- `Dockerfile` - one stage; the published image.
- `Caddyfile` -> `/etc/caddy/Caddyfile`.
- `html/index.html` -> `/srv/www/index.html`.
- `html/{swagger,redoc,elements,rapidoc,scalar}/index.html` -> `/srv/www/{viewer}/index.html`.
- Downloaded bundles -> `/srv/www/swagger/` (whole `dist`), `/srv/www/redoc/redoc.js`,
  `/srv/www/elements/elements.{js,css}`, `/srv/www/rapidoc/rapidoc.js`, `/srv/www/scalar/scalar.js`.
- `docker-compose.yml` - example service `apidoc` on port `8000`; `.docs/` - README screenshots.

## Configuration

- No environment variables and no `.env.dist`. The only runtime input is the `?url=` query parameter.
- `Caddyfile` listens on `:8000`, serves `/srv/www` with `file_server` and adds `Access-Control-Allow-Origin *`,
  `Access-Control-Allow-Methods "GET, OPTIONS"` and `Access-Control-Allow-Headers "Content-Type"`.
- To change Caddy behaviour, mount your own file over `/etc/caddy/Caddyfile`.

## Data

- No state. A spec file mounted under `/srv/www` is served read-only by path; nothing is written.

## Services

- Port `8000`, plain HTTP. Caddy's admin API listens on `localhost:2019` inside the container, as upstream
  defaults; it is not exposed.
- External: the host of the spec URL, which must allow CORS for the page origin, and `petstore3.swagger.io` for
  the default spec.

## Startup Flow

1. `CMD` starts `caddy run --config /etc/caddy/Caddyfile` directly as PID 1. There is no entrypoint and no
   `tini`; Caddy handles `SIGTERM` itself.

## Build and Publish

- `.github/workflows/docker.yml`: `test` builds `dockette/apidoc:latest-test` for `linux/amd64` with
  `docker/build-push-action` and curls six paths; `build` calls the reusable workflow for tag `latest` on
  `linux/amd64,linux/arm64`; `docs` updates the Docker Hub description on `master`.
- Triggers: `workflow_dispatch`, push to `master`, weekly on Monday 08:00 UTC.

## Testing

- `make build` and `make run` exist; there is no `make test`. CI runs its checks as inline workflow steps.
- CI checks HTTP 200 for `/`, `/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/` and `/scalar/`.
- Whether a viewer actually renders a spec is checked by hand in a browser.

## Decisions

### 2026-09-28 Bundle viewer assets at build time

- **Context:** Viewers are usually loaded from public CDNs, which fails offline and changes without notice.
- **Decision:** Download each pinned bundle in the `Dockerfile` and serve it from `/srv/www`.
- **Consequences:** (+) no CDN at runtime, versions visible in `ENV`; (-) a bump needs a rebuild and a manual
  check that the download path still exists.

### 2026-09-28 Caddy as a static file server

- **Context:** The image serves only static files and needs a CORS header.
- **Decision:** Caddy with a 10-line `Caddyfile` and `file_server`.
- **Consequences:** (+) one binary, no config templating; (-) Caddy comes unpinned from an extra apt repository.

## Known Limits

- The base is `debian:trixie-slim`, not `dockette/debian:trixie-slim`, and `LABEL maintainer` and the OCI labels
  don't follow the Dockerfile and image specs.
- The container runs as root and has no `HEALTHCHECK`.
- Downloads are not checksum-verified, and the Caddy GPG key is fetched with `curl` and piped to `gpg`.
- The `Dockerfile` uses `apt` instead of `apt-get`, installs without `--no-install-recommends`, runs
  `dist-upgrade` in its own layer and keeps `wget` and `unzip`, which no step uses.
- The `Makefile` has no `help` or `test` target, uses `IMAGE`/`TAG` instead of `DOCKER_IMAGE`/`DOCKER_TAG` and
  builds with `docker build`, not `docker buildx build`.
- The workflow uses `actions/checkout@v6`, runs the smoke test inline instead of `make test`, and the repository
  has no `.github/dependabot.yml` and no `.editorconfig`.
- The default spec is `petstore3.swagger.io`, so a viewer opened without `?url=` needs internet access.
- `.docs/landing.png` shows an older page title.
