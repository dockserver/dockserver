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
LABEL org.opencontainers.image.source https://github.com/dockserver/dockserver/

WORKDIR /tmp

COPY wiki/requirements.txt requirements.txt

RUN apk add --quiet --no-cache --no-progress git git-fast-import openssh \
    && apk add --quiet --no-cache --virtual .build gcc musl-dev \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --user -r requirements.txt \
    && apk del .build gcc musl-dev \
    && rm -rf /tmp/requirements.txt

WORKDIR /docs

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
