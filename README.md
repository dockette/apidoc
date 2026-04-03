<h1 align=center>Dockette / Apidoc</h1>

<p align=center>
   Dockerized OpenAPI documentation viewer. Swagger UI, Redoc, Stoplight Elements, RapiDoc and Scalar in one image.
</p>

<p align=center>
  <a href="https://hub.docker.com/r/dockette/apidoc/"><img src="https://badgen.net/docker/pulls/dockette/apidoc"></a>
  <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
  <a href="https://github.com/sponsors/f3l1x"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

------

## Prologue

Docker image bundling multiple OpenAPI/Swagger documentation renderers. Point any viewer at your spec via `?url=` parameter. All assets are bundled locally, no CDN calls at runtime.

## Viewers

| Viewer | Screenshot | URL | Description |
|--------|------------|-----|-------------|
| **Swagger UI** | ![](.docs/swagger.png) | `/swagger/?url=<spec>` | Classic interactive API explorer from [swagger.io](https://swagger.io/tools/swagger-ui/) |
| **Redoc** | ![](.docs/redoc.png) | `/redoc/?url=<spec>` | Clean, responsive, three-panel documentation from [Redocly](https://redocly.com/redoc) |
| **Stoplight Elements** | ![](.docs/elements.png) | `/elements/?url=<spec>` | Modern API documentation with try-it-out from [Stoplight](https://stoplight.io/open-source/elements) |
| **RapiDoc** | ![](.docs/rapidoc.png) | `/rapidoc/?url=<spec>` | Web component based API docs with customizable themes from [RapiDoc](https://rapidocweb.com/) |
| **Scalar** | ![](.docs/scalar.png) | `/scalar/?url=<spec>` | Beautiful, modern API reference from [Scalar](https://scalar.com/) |

### Landing Page

![](.docs/landing.png)

## Usage

```sh
docker run \
    --rm \
    -p 8000:8000 \
    dockette/apidoc
```

Then open:

- http://localhost:8000 — Landing page with all viewers
- http://localhost:8000/swagger/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/redoc/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/elements/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/rapidoc/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/scalar/?url=https://petstore3.swagger.io/api/v3/openapi.json

## Deployment

```yaml
services:
  apidoc:
    image: dockette/apidoc
    ports:
      - "8000:8000"
```

```sh
docker compose up
```

## Development

```sh
make build
make run
```

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to [support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
