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
if [ ! -z `command -v docker` ]; then
   dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -E 'dockserver')
   docker stop $dockers > /dev/null
   docker rm $dockers > /dev/null
   docker system prune -af > /dev/null
   unset $dockers
fi
}

function pulldockserver() {
if [ -z `command -v docker` ]; then
   docker pull -q docker.dockserver.io/dockserver/docker-dockserver
   docker run -d \
  --name=dockserver \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v /opt/dockserver:/opt/dockserver:rw \
  docker.dockserver.io/dockserver/docker-dockserver
fi
}

updates="update upgrade autoremove autoclean"
for upp in ${updates}; do
    sudo $(command -v apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
unset updates

packages=(curl bc tar git jq pv pigz tzdata rsync)
log "**** install build packages ****" && \
sudo $(command -v apt) install $packages -yqq 1>/dev/null 2>&1 && clear
unset packages

remove=(/bin/dockserver /usr/bin/dockserver)
log "**** remove old dockserver bins ****" && \
sudo $(command -v rm) -rf $remove 1>/dev/null 2>&1 && clear
unset remove

if [ -z `command -v docker` ]; then
   curl -fsSL https://get.docker.com -o /tmp/docker.sh && bash /tmp/docker.sh
   systemctl reload-or-restart docker.service
fi

if [ -z `command -v docker-compose` ]; then
   curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
   ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
   chmod +x /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

if [[ ! -d "/opt/dockserver" ]]; then
   mkdir -p /opt/dockserver
fi

file=/opt/dockserver/.installer/dockserver
store=/usr/bin/dockserver
dockserver=/opt/dockserver

while true; do
if [ "$(ls -A $dockserver)" ]; then
   rmdocker && sleep 3 && break
else
   pulldockserver
   echo "dockserver is not pulled yet" 
   sleep 5 && continue
fi
done

if [[ -f $store ]]; then
   $(command -v rm) $store
fi
if [[ $EUID != 0 ]]; then
    $(command -v chown) -R $(whoami):$(whoami) ${dockserver}
    $(command -v usermod) -aG sudo $(whoami)
    ln -sf $file $store && chmod +x $store $file
    $(command -v chown) $(whoami):$(whoami) $store $file
else 
    $(command -v chown) -R 1000:1000 ${dockserver}
    ln -sf $file $store && chmod +x $store $file
    $(command -v chown) -R 1000:1000 $store $file
fi

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     install dockserver
     [ sudo ] dockserver -i

     all commands
     [ sudo ] dockserver -h / --help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
" 
#EOF#
