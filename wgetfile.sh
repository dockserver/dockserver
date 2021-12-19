#!/bin/bash
####################################
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
# shellcheck disable=SC2086
# shellcheck disable=SC2046

function log() {
   echo "[INSTALL] DockServer ${1}"
}

function rmdocker() {
   dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d')
   docker stop $dockers > /dev/null
   docker rm $dockers > /dev/null
   docker system prune -af > /dev/null
   unset $dockers
}

function pulldockserver() {
docker run -d \
  --name=dockserver \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v /opt/dockserver:/opt/dockserver:rw \
  ghcr.io/dockserver/docker-dockserver:latest
}

updates="update upgrade autoremove autoclean"
for upp in ${updates}; do
    sudo $(command -v apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
unset updates

packages=(curl bc tar git jq pv pigz tzdata rsync)
log "**** install build packages ****" && \
sudo $(command -v apt) install $packages -yqq 1>/dev/null 2>&1 && clear
unset install

remove=(/bin/dockserver /usr/bin/dockserver)
log "**** install build packages ****" && \
sudo $(command -v rm) -rf $packages 1>/dev/null 2>&1 && clear
unset remove

if ! docker --version > /dev/null; then
   curl -fsSL https://get.docker.com -o /tmp/docker.sh && bash /tmp/docker.sh
fi
if ! docker-compose --version > /dev/null; then
   apt install curl -yqq && \
   curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
   ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
   chmod +x /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

if [[ ! -d "/opt/dockserver" ]]; then
   mkdir -p /opt/dockserver
fi

rmdocker
pulldockserver
rmdocker

file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
dockserver=/opt/dockserver
while true; do
if [ "$(ls -A $dockserver)" ]; then
    sleep 3 && break
else
    echo "$dockserver is not pulled yet" 
    sleep 5 && continue
fi
done

if [[ -f "/bin/dockserver" ]]; then $(command -v rm) $store && $(command -v rsync) $file $store -aqhv; else $(command -v rsync) $file $store -aqhv; fi
if [[ $EUID != 0 ]]; then
    $(command -v chown) -R $(whoami):$(whoami) ${dockserver}
    $(command -v usermod) -aG sudo $(whoami)
    $(command -v chown) $(whoami):$(whoami) /bin/dockserver
fi
if [[ $EUID == 0 ]]; then $(command -v chown) -R 1000:1000 ${dockserver} && $(command -v chown) 1000:1000 /bin/dockserver; fi
$(command -v chmod) 0775 /bin/dockserver

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ EASY MODE ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     to install dockserver
     [ sudo ] dockserver -i

     You want to see all Commands
     [ sudo ] dockserver -h
     [ sudo ] dockserver --help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
" 
#EOF#
