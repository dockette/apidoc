# dockette/apidoc

Dockerized OpenAPI documentation viewer bundling multiple GUI renderers. Point any viewer at your OpenAPI spec via URL.

## Included Viewers

| Viewer | Path | Description |
|--------|------|-------------|
| **Swagger UI** | `/swagger/?url=<spec>` | Classic interactive API explorer |
| **Redoc** | `/redoc/?url=<spec>` | Clean three-panel documentation |
| **Stoplight Elements** | `/elements/?url=<spec>` | Modern docs with try-it-out |
| **RapiDoc** | `/rapidoc/?url=<spec>` | Customizable web component docs |
| **Scalar** | `/scalar/?url=<spec>` | Beautiful modern API reference |

## Screenshots

### Landing Page

![](.docs/landing.png)

### Swagger UI

![](.docs/swagger.png)

### Redoc

![](.docs/redoc.png)

### Stoplight Elements

![](.docs/elements.png)

### RapiDoc

![](.docs/rapidoc.png)

### Scalar

![](.docs/scalar.png)

## Usage

```bash
docker run --rm -p 8000:8000 dockette/apidoc
```

Then open:

- http://localhost:8000 — Landing page with all viewers
- http://localhost:8000/swagger/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/redoc/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/elements/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/rapidoc/?url=https://petstore3.swagger.io/api/v3/openapi.json
- http://localhost:8000/scalar/?url=https://petstore3.swagger.io/api/v3/openapi.json

## Docker Compose

```yaml
services:
  apidoc:
    image: dockette/apidoc
    ports:
      - "8000:8000"
```

```bash
docker compose up
```

## Build

```bash
make build
make run
```

## License

MIT
