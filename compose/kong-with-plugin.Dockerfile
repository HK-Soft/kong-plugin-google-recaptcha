FROM kong:2.8.1

# Running in db-less mode
ENV KONG_DATABASE off
# load the plugin google-recaptcha
ENV KONG_PLUGINS bundled, google-recaptcha

USER root

# Required packages to install plugin using luarocks
RUN apk update
RUN apk add git
RUN apk add wget
RUN apk add zip
RUN apk add gcc
RUN apk add musl-dev

# Installing kong plugin as lua modules
RUN luarocks install kong-plugin-google-recaptcha
