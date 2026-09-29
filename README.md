<h1 align=center>Dockette / Apidoc</h1>

<p align=center>
   <a href="https://github.com/dockette/apidoc/actions"><img src="https://github.com/dockette/apidoc/actions/workflows/docker.yml/badge.svg" alt="GitHub Actions"></a>
   <a href="https://hub.docker.com/r/dockette/apidoc"><img src="https://img.shields.io/docker/pulls/dockette/apidoc.svg" alt="Docker Hub pulls"></a>
   <a href="https://github.com/sponsors/f3l1x"><img src="https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ea4aaa" alt="GitHub Sponsors"></a>
   <a href="https://github.com/orgs/dockette/discussions"><img src="https://img.shields.io/badge/support-discussions-6f42c1" alt="Support/Discussions"></a>
</p>

<p align=center>
   Five OpenAPI viewers in one Docker image: <a href="https://github.com/swagger-api/swagger-ui">Swagger UI</a>, <a href="https://github.com/Redocly/redoc">Redoc</a>, <a href="https://github.com/stoplightio/elements">Stoplight Elements</a>, <a href="https://github.com/rapi-doc/RapiDoc">RapiDoc</a> and <a href="https://github.com/scalar/scalar">Scalar</a>, served by Caddy on Debian Trixie. For developers who want to read an OpenAPI spec in the browser and compare viewers with one URL.
</p>

<p align=center>
   <img src=".docs/landing.png" alt="Apidoc landing page" width="100%">
</p>

-----

## Usage

Run the image and open `http://localhost:8000`:

```sh
docker run -p 8000:8000 dockette/apidoc
```

The image serves five OpenAPI viewers with Caddy, and every viewer asset is inside the container, so it needs no
configuration. Each viewer loads the spec from its `url` query parameter, for example
`/redoc/?url=https://petstore3.swagger.io/api/v3/openapi.json`, and the browser fetches it, so a spec on another
host must allow CORS. To serve your own spec, mount it under `/srv/www`; see the
[OpenAPI Specification](https://spec.openapis.org/oas/latest.html) for the format.

> [!CAUTION]
> The container runs as root and serves plain HTTP with no authentication. Don't expose port `8000` to the
> internet; put a proxy with TLS in front of it.

## Versions

| Tag | Viewers |
|-----|---------|
| `dockette/apidoc:latest` | Swagger UI `5.33.0`, Redoc `2.5.4`, Stoplight Elements `9.0.25`, RapiDoc `9.3.8`, Scalar `1.72.1` |

The tag is built for `linux/amd64` and `linux/arm64` and rebuilt every Monday.

## Viewers

### Swagger UI

The interactive API explorer from [Swagger UI](https://swagger.io/tools/swagger-ui/) `5.33.0`, at
`/swagger/?url=<spec>`.

<img src=".docs/swagger.png" alt="Swagger UI" width="100%">

### Redoc

A three-panel reference from [Redoc](https://redocly.com/redoc) `2.5.4`, at `/redoc/?url=<spec>`.

<img src=".docs/redoc.png" alt="Redoc" width="100%">

### Stoplight Elements

API docs with a sidebar and try-it requests from [Stoplight Elements](https://stoplight.io/open-source/elements)
`9.0.25`, at `/elements/?url=<spec>`.

<img src=".docs/elements.png" alt="Stoplight Elements" width="100%">

### RapiDoc

A web component with try-it requests and authentication from [RapiDoc](https://rapidocweb.com/) `9.3.8`, at
`/rapidoc/?url=<spec>`.

<img src=".docs/rapidoc.png" alt="RapiDoc" width="100%">

### Scalar

An API reference with request examples from [Scalar](https://scalar.com/) `1.72.1`, at `/scalar/?url=<spec>`.

<img src=".docs/scalar.png" alt="Scalar" width="100%">

## Development

```sh
make build   # build the image
make run     # run it on port 8000
```

Run `make` to list every target.

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider [supporting](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
