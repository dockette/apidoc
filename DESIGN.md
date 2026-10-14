# Apidoc Design

The Apidoc image serves a landing page and five OpenAPI viewer pages on port `8000`. Developers open it in a
browser to read an API spec, pick a viewer and compare how each one renders the same spec.

## Principles

- **One spec URL, five viewers.** Every page takes the spec from `?url=`, so the same link works in each viewer
  by changing only the path (`/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/`, `/scalar/`).
- **Upstream look, thin wrapper.** Each viewer page only mounts the upstream bundle and passes the URL. We set a
  few options and never restyle the viewers.
- **No build step for our pages.** `html/` is plain HTML with inline CSS and inline JavaScript; no framework, no
  bundler, no external font.
- **A spec always renders.** Without `?url=`, every viewer falls back to the Petstore spec
  `https://petstore3.swagger.io/api/v3/openapi.json`, so a first start shows real content.

## Inventory

- Landing page: `html/index.html`, served at `/`. A URL form with five buttons, then one card per viewer.
- Swagger UI: `html/swagger/index.html`, `StandaloneLayout` with the top bar and the `DownloadUrl` plugin,
  `deepLinking: true`. Assets from the Swagger UI `dist` folder.
- Redoc: `html/redoc/index.html`, `Redoc.init` with `scrollYOffset: 0` and one theme option, the primary color.
- Stoplight Elements: `html/elements/index.html`, the `<elements-api>` web component with `layout="sidebar"` and
  `router="hash"`.
- RapiDoc: `html/rapidoc/index.html`, the `<rapi-doc>` web component with `theme="light"`, `render-style="read"`,
  header, try-it and authentication enabled.
- Scalar: `html/scalar/index.html`, the `#api-reference` script tag with `data-url` set from `?url=`.
- Upstream projects: [Swagger UI](https://github.com/swagger-api/swagger-ui),
  [Redoc](https://github.com/Redocly/redoc), [Stoplight Elements](https://github.com/stoplightio/elements),
  [RapiDoc](https://github.com/rapi-doc/RapiDoc), [Scalar](https://github.com/scalar/scalar).

## Layout

- Landing page: one centered column, `max-width: 800px`, `80px` top margin, `20px` side padding.
- Order: title, subtitle, the URL form card, the "Available Viewers" heading, five viewer cards.
- Viewer pages: upstream layout, full page; our CSS only removes the body margin and sets `height: 100vh` where
  the web component needs it (Elements, RapiDoc).

## Typography

- Landing page: the system font stack (`-apple-system`, `BlinkMacSystemFont`, `Segoe UI`, `Roboto`,
  `sans-serif`), `2rem` title, `1.25rem` card titles, `0.9rem` body text in cards.
- Viewer pages: upstream fonts.

## Colors and Themes

- The landing page colors are inline in the `<style>` block of `html/index.html`: light grey background, white
  cards, blue links and buttons.
- Redoc uses the same blue as its primary color, set in `html/redoc/index.html`, so the two pages match.
- RapiDoc is fixed to its light theme by the `theme` attribute. Other viewers use their upstream default theme.
- There is no theme switch and no environment variable that changes colors.

## States

- First start: `/` shows the form with the Petstore URL filled in; each button opens that spec.
- Empty URL field: the button shows a browser `alert()` and stays on the page.
- Unreachable spec or a host without CORS: each viewer shows its own upstream error; the landing page does not
  check the URL.
- Unknown path: Caddy returns its default empty 404. The container prints only the Caddy log.

## Accessibility

- The URL input has a `<label for="specUrl">`; the viewer buttons are real `<button>` elements, keyboard
  reachable.
- The viewer cards are not links; only the buttons open a viewer. The cards show the URL pattern as code.
- The buttons need JavaScript. With JavaScript off, you type the `/{viewer}/?url=` link by hand.
- Viewer pages: whatever upstream provides; our wrappers add nothing and remove nothing.

## Dark Mode

- Not supported on the landing page. RapiDoc is forced to light. Swagger UI, Redoc, Elements and Scalar behave
  as upstream does at the pinned version.

## Responsive

- The landing page has a viewport meta tag, a fluid column and wrapping buttons (`flex-wrap: wrap`); it works on
  a phone.
- Viewer pages are as responsive as upstream at the pinned version. Our wrappers are not tested on narrow screens.

## Screenshots

- `.docs/landing.png`, `.docs/swagger.png`, `.docs/redoc.png`, `.docs/elements.png`, `.docs/rapidoc.png`,
  `.docs/scalar.png`, all used by the README.
- To retake them, run `make build` and `make run`, open each viewer with the Petstore spec and capture the first
  screen of a desktop window.
- `.docs/landing.png` shows the older title "API Documentation Viewer"; the page now says "Dockette Apidoc".

## Changing the UI

- The paths `/swagger/`, `/redoc/`, `/elements/`, `/rapidoc/`, `/scalar/` and the `?url=` parameter are public;
  users bookmark and share these links. Don't rename them.
- A viewer bump can rename its bundle files or change how the URL is passed (attribute, property or data
  attribute); open the viewer after every bump.
- A new viewer needs a folder in `html/`, a button and a card in `html/index.html`, a README block and a
  screenshot in `.docs/`.
- Keep the Petstore fallback in every viewer page and in the landing form, so all six pages open the same spec.

## Checklist

- [ ] `/` loads and every button opens its viewer with the URL from the field
- [ ] Each viewer renders the Petstore spec with no `?url=`
- [ ] Each viewer renders a spec passed by `?url=`, including one served from this container
- [ ] The landing page works at phone width
- [ ] Screenshots in `.docs/` are retaken when a page changes visibly
