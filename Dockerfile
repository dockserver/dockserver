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

#COPY requirements.txt requirements.txt
COPY wiki/ /
COPY wiki/mkdocs.yml /docs/mkdocs.yml

# Perform build and cleanup artifacts
RUN apk add --no-cache \
    git curl \
    && apk add --no-cache --virtual .build gcc musl-dev \
    && pip install --user -r /docs/requirements.txt \
    && apk del .build gcc musl-dev \
    && rm -rf /tmp/*

ENV PATH=$PATH:/root/.local/bin

RUN cd /docs && mkdocs build

WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
