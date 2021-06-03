#####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
#####################################
# THIS DOCKER IS UNDER LICENSE      #
# NO CUSTOMIZING IS ALLOWED         #
# NO REBRANDING IS ALLOWED          #
# NO CODE MIRRORING IS ALLOWED      #
#####################################
FROM ghcr.io/squidfunk/mkdocs-material:latest
LABEL maintainer=dockserver
LABEL org.opencontainers.image.source https://github.com/dockserver/docker-wiki/

# Set build directory
WORKDIR /tmp

COPY wiki/requirements.txt /tmp/requirements.txt

RUN apk --quiet --no-cache --no-progress git curl \
    && apk add --no-cache --virtual .build gcc musl-dev \
    && python3 -m pip install --user -r /tmp/requirements.txt \
    && apk del .build gcc musl-dev \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

ENV PATH=$PATH:/root/.local/bin

WORKDIR /docs
EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
