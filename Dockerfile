FROM alpine:3
MAINTAINER Stewart Park <hello@stewartjpark.com>

# Configurations
ARG ARCH=amd64
ARG CONFD_VERSION=0.16.0

# Install confd
RUN wget -O /usr/local/bin/confd \
    https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-${ARCH} && \
    chmod +x /usr/local/bin/confd

# Install HAProxy
RUN apk add --no-cache haproxy

# Copy files
COPY docker-entrypoint.sh /
COPY config.toml /etc/confd/conf.d/
COPY haproxy.cfg.tmpl /etc/confd/templates/

ENTRYPOINT ["/docker-entrypoint.sh"]
