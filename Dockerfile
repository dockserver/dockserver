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

FROM python:3.9.2-alpine3.13
LABEL maintainer=dockserver
LABEL org.opencontainers.image.source https://github.com/dockserver/docker-wiki/

ARG WITH_PLUGINS=true
ENV PACKAGES=/usr/local/lib/python3.9/site-packages
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /tmp

RUN \
  echo "**** install build packages ****" && \
  apk --quiet --no-cache --no-progress update && \
  apk --quiet --no-cache --no-progress upgrade && \
  apk --quiet --no-cache --no-progress add git openssh gcc musl-dev && \
  rm -rf /var/cache/apk/*

VOLUME [ "/docs" ]
COPY wiki/ /

RUN \
  python3 -m pip install --upgrade pip && \
  python3 -m pip install -r /docs/requirements.txt && \
  rm -rf /tmp/* /root/.cache && \
  find ${PACKAGES} -type f -path "*/__pycache__/*" -exec rm -f {} \;

EXPOSE 8000

ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
