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
   dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep 'dockserver')
   $(which docker) stop $dockers > /dev/null
   $(which docker) rm $dockers > /dev/null
   $(which docker) system prune -af > /dev/null
   unset $dockers
fi
}

function pulldockserver() {
if [ $(which docker) ]; then
   $(which docker) pull -q docker.dockserver.io/dockserver/docker-dockserver
   $(which docker) run -d \
   --name=dockserver \
   -e PUID=1000 -e PGID=1000 -e TZ=Europe/London \
   -v /opt/dockserver:/opt/dockserver:rw \
   docker.dockserver.io/dockserver/docker-dockserver
   $(which chown) -R 1000:1000 /opt/dockserver
fi
}

function upsys() {
log "**** update system ****"
updates="update upgrade autoremove autoclean"
for upp in ${updates}; do
    sudo $(command -v apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
unset updates

log "**** install build packages ****"
packages="curl bc sudo wget tar git jq pv pigz tzdata rsync"
for pack in ${packages}; do
    sudo $(command -v apt) $pack -yqq 1>/dev/null 2>&1
done
unset packages

log "**** remove old links  ****"
remove="/bin/dockserver /usr/bin/dockserver"
for rmold in ${packages}; do
    sudo $(command -v rm) -rf $rmold 1>/dev/null 2>&1
done
unset remove

if [ $(which snapd) ]; then
   log "**** snapd  ****" && \
   if [[ -d "/var/cache/snapd/" ]];then
      sudo $(which rm) -rf /var/cache/snapd/
   fi
   sudo $(which apt) autoremove --purge snapd gnome-software-plugin-snap -yqq && \
   sudo $(which apt) autoclean -yqq
fi
}

function dockcomp() {
if [ ! $(which docker) ] && [ $(docker --version) ]; then
   log "**** installing now docker ****" && \
   $(which wget) -qO- https://get.docker.com/ | sh >/dev/null 2>&1 && \
   $(which systemctl) reload-or-restart docker.service
fi

if [ ! $(which docker-compose) ]; then
   log "**** installing now docker-composer ****" && \
   $(which curl) -fsSL --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
   $(which ln) -sf /usr/local/bin/docker-compose /usr/bin/docker-compose && \
   $(which chmod) +x /usr/local/bin/docker-compose /usr/bin/docker-compose
fi
}

function finalend() {
if test -f "/usr/bin/dockserver"; then $(which rm) /usr/bin/dockserver ; fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/dockserver
    $(which usermod) -aG sudo $(whoami)
    $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver
    $(which ln) -sf /usr/bin/dockserver /bin/dockserver
    $(which chmod) +x /usr/bin/dockserver
    $(which chown) $(whoami):$(whoami) /usr/bin/dockserver 
else 
    $(which chown) -R 1000:1000 /opt/dockserver
    $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver
    $(which ln) -sf /usr/bin/dockserver /bin/dockserver
    $(which chmod) +x /usr/bin/dockserver
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
}

#### run in order

upsys && dockcomp

[[ ! -d "/opt/dockserver" ]] && mkdir -p /opt/dockserver

file=/opt/dockserver/.installer/dockserver
store=/usr/bin/dockserver
dockserver=/opt/dockserver

while true; do
   if [ "$(ls -A $dockserver)" ]; then
      rmdocker && sleep 3 && break
   else
      pulldockserver && \
      log "**** dockserver is not pulled yet ****" && \
      log "**** this could take some time ****" && \
      sleep 5 && continue
   fi
done

finalend

#EOF#
