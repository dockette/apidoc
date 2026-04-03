FROM debian:bookworm-slim

# METADATA #####################################################################
LABEL maintainer="dockette <https://github.com/dockette>"
LABEL description="Dockerized OpenAPI documentation viewer with Swagger UI, Redoc, Stoplight Elements, RapiDoc and Scalar"

# VERSIONS #####################################################################
ENV SWAGGER_UI_VERSION=5.21.0
ENV REDOC_VERSION=2.5.0
ENV STOPLIGHT_ELEMENTS_VERSION=9.0.16
ENV RAPIDOC_VERSION=9.3.8
ENV SCALAR_VERSION=2.0.18

# INSTALLATION #################################################################
RUN apt update && \
    apt dist-upgrade -y

# DEPENDENCIES #################################################################
RUN apt install -y \
        wget \
        curl \
        ca-certificates \
        unzip && \
    # CLEAN UP #################################################################
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# CADDY ########################################################################
RUN apt update && \
    apt install -y debian-keyring debian-archive-keyring apt-transport-https && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt update && \
    apt install -y caddy && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# DOCUMENT ROOT ################################################################
RUN mkdir -p /srv/www

# SWAGGER UI ###################################################################
RUN curl -sSL -o /tmp/swagger-ui.tar.gz \
        https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${SWAGGER_UI_VERSION}.tar.gz && \
    tar -xzf /tmp/swagger-ui.tar.gz -C /tmp && \
    mv /tmp/swagger-ui-${SWAGGER_UI_VERSION}/dist /srv/www/swagger && \
    rm -rf /tmp/swagger-ui* && \
    rm -f /srv/www/swagger/index.html /srv/www/swagger/swagger-initializer.js

# REDOC ########################################################################
RUN mkdir -p /srv/www/redoc && \
    curl -sSL -o /srv/www/redoc/redoc.standalone.js \
        https://cdn.redoc.ly/redoc/v${REDOC_VERSION}/bundles/redoc.standalone.js

# STOPLIGHT ELEMENTS ###########################################################
RUN mkdir -p /srv/www/elements && \
    curl -sSL -o /srv/www/elements/web-components.min.js \
        https://unpkg.com/@stoplight/elements@${STOPLIGHT_ELEMENTS_VERSION}/web-components.min.js && \
    curl -sSL -o /srv/www/elements/styles.min.css \
        https://unpkg.com/@stoplight/elements@${STOPLIGHT_ELEMENTS_VERSION}/styles.min.css

# RAPIDOC ######################################################################
RUN mkdir -p /srv/www/rapidoc && \
    curl -sSL -o /srv/www/rapidoc/rapidoc-min.js \
        https://unpkg.com/rapidoc@${RAPIDOC_VERSION}/dist/rapidoc-min.js

# SCALAR #######################################################################
RUN mkdir -p /srv/www/scalar && \
    curl -sSL -o /srv/www/scalar/api-reference.js \
        https://cdn.jsdelivr.net/npm/@scalar/api-reference

# HTML PAGES ###################################################################
COPY html/ /srv/www/

# CADDYFILE ####################################################################
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 8000

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
