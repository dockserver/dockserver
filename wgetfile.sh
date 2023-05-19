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
if [ $(which docker) ]; then
   dockers=$(docker ps -a --format '{{.Names}}' | sed '/^$/d' | grep -E 'dockserver')
   $(which docker) stop $dockers > /dev/null
   $(which docker) rm $dockers > /dev/null
   $(which docker) system prune -af > /dev/null
   unset $dockers
fi
}

function pulldockserver() {
if [ $(which docker) ]; then
   $(which docker) pull -q ghcr.io/dockserver/docker-dockserver:latest && \
   $(which docker) run -d \
  --name=dockserver \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v /opt/dockserver:/opt/dockserver:rw \
  ghcr.io/dockserver/docker-dockserver:latest
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

if [ ! $(which docker) ]; then
   $(which curl) -fsSL https://get.docker.com -o /tmp/docker.sh && bash /tmp/docker.sh
   $(which systemctl) reload-or-restart docker.service
fi

if [ ! $(which docker-compose) ]; then
    $(which curl) -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
    $(which ln) -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    $(which chmod) +x /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

[[ ! -d "/opt/dockserver" ]] && mkdir -p /opt/dockserver

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

if test -f "/usr/bin/dockserver"; then $(which rm) /usr/bin/dockserver ; fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/dockserver
    $(which usermod) -aG sudo $(whoami)
    cp /opt/dockserver/.installer/dockserver /usr/bin/dockserver
    ln -sf /usr/bin/dockserver /bin/dockserver
    chmod +x /usr/bin/dockserver
    $(which chown) $(whoami):$(whoami) /usr/bin/dockserver 
else 
    $(which chown) -R 1000:1000 /opt/dockserver
    cp /opt/dockserver/.installer/dockserver /usr/bin/dockserver
    ln -sf /usr/bin/dockserver /bin/dockserver
    chmod +x /usr/bin/dockserver
    $(which chown) -R 1000:1000 /usr/bin/dockserver
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
