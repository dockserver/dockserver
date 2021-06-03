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

ENV PACKAGES=/usr/local/lib/python3.9/site-packages
ENV PYTHONDONTWRITEBYTECODE=1
# Set build directory
WORKDIR /tmp

COPY wiki/requirements.txt /tmp/requirements.txt

RUN apk add --quiet --no-cache --no-progress git curl \
    && apk add --quiet --no-cache --virtual .build gcc musl-dev \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --user -r /tmp/requirements.txt \
    && apk del .build gcc musl-dev \
    && rm -rf /tmp/requirements.txt \
    && rm -rf /tmp/* && rm -rf /var/cache/apk/* && rm -rf /tmp/* /root/.cache \
    && find ${PACKAGES} -type f  -path "*/__pycache__/*" -exec rm -f {} \;

ENV PATH=$PATH:/root/.local/bin

WORKDIR /docs
EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
