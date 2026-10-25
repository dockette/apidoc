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

Docker image bundling OpenAPI documentation viewers: Swagger UI, Redoc, Stoplight Elements, RapiDoc and Scalar. Point
any viewer at your spec with the `?url=` parameter.

## Features

- Five viewers and a landing page, served by Caddy on port `8000`
- All assets are bundled locally, no CDN calls at runtime

## Viewers

<table>
  <tr>
    <th colspan="3">Swagger UI</th>
  </tr>
  <tr>
    <td colspan="3"><img src=".docs/swagger.png" alt="Swagger UI" width="100%"></td>
  </tr>
  <tr>
    <td><code>/swagger/?url=&lt;spec&gt;</code></td>
    <td>Classic interactive API explorer</td>
    <td><a href="https://swagger.io/tools/swagger-ui/">swagger.io</a></td>
  </tr>
  <tr>
    <th colspan="3">Redoc</th>
  </tr>
  <tr>
    <td colspan="3"><img src=".docs/redoc.png" alt="Redoc" width="100%"></td>
  </tr>
  <tr>
    <td><code>/redoc/?url=&lt;spec&gt;</code></td>
    <td>Clean, responsive, three-panel documentation</td>
    <td><a href="https://redocly.com/redoc">Redocly</a></td>
  </tr>
  <tr>
    <th colspan="3">Stoplight Elements</th>
  </tr>
  <tr>
    <td colspan="3"><img src=".docs/elements.png" alt="Stoplight Elements" width="100%"></td>
  </tr>
  <tr>
    <td><code>/elements/?url=&lt;spec&gt;</code></td>
    <td>Modern API documentation with try-it-out</td>
    <td><a href="https://stoplight.io/open-source/elements">Stoplight</a></td>
  </tr>
  <tr>
    <th colspan="3">RapiDoc</th>
  </tr>
  <tr>
    <td colspan="3"><img src=".docs/rapidoc.png" alt="RapiDoc" width="100%"></td>
  </tr>
  <tr>
    <td><code>/rapidoc/?url=&lt;spec&gt;</code></td>
    <td>Web component based API docs with customizable themes</td>
    <td><a href="https://rapidocweb.com/">RapiDoc</a></td>
  </tr>
  <tr>
    <th colspan="3">Scalar</th>
  </tr>
  <tr>
    <td colspan="3"><img src=".docs/scalar.png" alt="Scalar" width="100%"></td>
  </tr>
  <tr>
    <td><code>/scalar/?url=&lt;spec&gt;</code></td>
    <td>Beautiful, modern API reference</td>
    <td><a href="https://scalar.com/">Scalar</a></td>
  </tr>
</table>

### Landing Page

<img src=".docs/landing.png" alt="Landing Page" width="100%">

## Usage

```sh
docker run --rm -p 8000:8000 dockette/apidoc

# Landing page with all viewers
open http://localhost:8000

# Viewers, with a spec in the `url` parameter
open 'http://localhost:8000/swagger/?url=https://petstore3.swagger.io/api/v3/openapi.json'
open 'http://localhost:8000/redoc/?url=https://petstore3.swagger.io/api/v3/openapi.json'
open 'http://localhost:8000/elements/?url=https://petstore3.swagger.io/api/v3/openapi.json'
open 'http://localhost:8000/rapidoc/?url=https://petstore3.swagger.io/api/v3/openapi.json'
open 'http://localhost:8000/scalar/?url=https://petstore3.swagger.io/api/v3/openapi.json'
```

## Configuration

Run it with Docker Compose:

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

## Versions

| Version | Release |
|---------|---------|
| `dockette/apidoc:YYYY.MM.DD` | release `YYYY.MM.DD` |
| `dockette/apidoc:latest` | latest build of `master` |

Releases are listed on [GitHub](https://github.com/dockette/apidoc/releases).

## Development

```sh
make build     # build the image
make run       # run the image on port 8000
make push      # push the image
make version   # print VERSION
make release   # set today's date in VERSION
```

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to
[support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
