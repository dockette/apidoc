# Apidoc PRD

Apidoc is a service image that serves Swagger UI, Redoc, Stoplight Elements, RapiDoc and Scalar from one
container on port `8000`, with a landing page to pick a viewer for any OpenAPI spec URL.

## Problem

An OpenAPI spec is a JSON or YAML file; reading it needs a viewer. Each viewer has its own install steps, CDN
links and way of taking the spec URL, and teams argue about which one to use. Trying all five means five setups.

## Users

- Backend developers who have an OpenAPI spec and want to read or share it in a browser.
- Teams that add a docs container to a local or staging Compose stack next to their API.
- They know `docker run` and Compose basics; they don't want to write HTML or configure a web server.

## Goals

- One `docker run -p 8000:8000 dockette/apidoc` serves all five viewers and the landing page.
- The same `?url=` parameter works in every viewer, so switching viewers changes only the path.
- Viewer JavaScript and CSS are served from the container; the browser loads no viewer asset from a CDN.
- Viewer versions are pinned in the `Dockerfile` and rebuilt weekly on `linux/amd64` and `linux/arm64`.
- Without a `?url=`, every viewer shows the Petstore spec, so a first start shows real content.

## Non-goals

- No spec hosting or editing, because the image only renders a spec that lives elsewhere or is mounted.
- No authentication, because it is meant for local and internal use behind your own proxy.
- No TLS, because Caddy listens on plain HTTP `:8000` and TLS belongs to the proxy in front.
- No custom themes or branding options, because the viewers stay as close to upstream as possible.
- No server-side spec fetching or proxy, because the spec is loaded by the browser and must allow CORS.

## Scope

- Landing page at `/`: a spec URL field, one button per viewer and a card per viewer with its URL pattern.
- Viewers at `/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/` and `/scalar/`, each reading `?url=`.
- Static file serving of everything under `/srv/www`, so a spec mounted there is reachable by path.
- CORS header `Access-Control-Allow-Origin *` on every response from the container.
- One tag, `latest`. The README shows `docker run` and a Compose example.

## Success Criteria

- `docker run --rm -p 8000:8000 dockette/apidoc` starts, and `curl -sf http://localhost:8000/` returns the
  landing page.
- `curl -sf` returns 200 for `/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/` and `/scalar/`; CI checks all six
  paths on every build.
- Each viewer renders `https://petstore3.swagger.io/api/v3/openapi.json` in a browser.
- `docker compose up` with the repository `docker-compose.yml` serves the same pages.

## Out of Scope

- A single Redoc image with its own build: see `dockette/redoc`.
- Browsing Markdown or other docs formats: see `dockette/viewdoc`.
- Viewer features and bugs: report them to the upstream project linked in `DESIGN.md`.

## Open Questions

- 2026-09-28: Should the image run as a non-root user and declare a `HEALTHCHECK`, as the service class requires?
- 2026-09-28: Should the default Petstore fallback be replaced by a spec bundled in the image, so a first start
  works offline?
