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
   $SUID echo "[INSTALL] DockServer ${1}"
}

function rmdocker() {
if [ $(which docker) ]; then
   dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep 'dockserver')
   if [[ $dockers != "" ]]; then
      $SUID $(which docker) stop $dockers > /dev/null
      $SUID $(which docker) rm $dockers > /dev/null
      $SUID $(which docker) system prune -af > /dev/null
   fi
   unset $dockers
fi
}

function pulldockserver() {
if [ $(which docker) ]; then
   $SUID $(which docker) pull -q docker.dockserver.io/dockserver/docker-dockserver
   $SUID $(which docker) run -d \
   --name=dockserver \
   -e PUID=1000 -e PGID=1000 -e TZ=Europe/London \
   -v /opt/dockserver:/opt/dockserver:rw \
   docker.dockserver.io/dockserver/docker-dockserver
   $SUID $(which chown) -R 1000:1000 /opt/dockserver
fi
}

function upsys() {
log "**** update system ****"
updates="update upgrade autoremove autoclean"
for upp in ${updates}; do
    $SUID $(which apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
unset updates

log "**** install build packages ****"
packages="curl bc sudo wget tar git jq pv pigz tzdata rsync"
for pack in ${packages}; do
    $SUID $(which apt) $pack -yqq 1>/dev/null 2>&1
done
unset packages

log "**** remove old links  ****"
remove="/bin/dockserver /usr/bin/dockserver"
for rmold in ${remove}; do
    $SUID $(which rm) -rf $rmold 1>/dev/null 2>&1
done
unset remove

if [ $(which snapd) ]; then
   log "**** snapd  ****" && \
   if [[ -d "/var/cache/snapd/" ]];then
      $SUID $(which rm) -rf /var/cache/snapd/
   fi
   $SUID $(which apt) autoremove --purge snapd gnome-software-plugin-snap -yqq && \
   $SUID $(which apt) autoclean -yqq
fi
}

function dockcomp() {
if [ ! $(which docker) ]; then
   log "**** installing now docker ****" && \
   $SUID $(which wget) -qO- https://get.docker.com/ | sh >/dev/null 2>&1 && \
   $SUID $(which systemctl) reload-or-restart docker.service
fi

if [ ! $(which docker-compose) ]; then
   export DOCKER_CONFIG=${DOCKER_CONFIG:-/opt/appdata/.docker}
   VERSION="$($(which curl) -sX GET https://api.github.com/repos/docker/compose/releases/latest | jq --raw-output '.tag_name')"
   ARCH=$(uname -m)
   log "installing now docker composer $VERSION on $ARCH ...." && \
   $SUID $(which mkdir) $DOCKER_CONFIG/cli-plugins && \
   $SUID $(which curl) -fsSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-linux-${ARCH}" -o $DOCKER_CONFIG/cli-plugins/docker-compose
   if test -f $DOCKER_CONFIG/cli-plugins/docker-compose;then
      $SUID $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose && \
      $SUID $(which rm) -f /usr/bin/docker-compose /usr/local/bin/docker-compose && \
      $SUID $(which cp) -r $DOCKER_CONFIG/cli-plugins/docker-compose /usr/bin/docker-compose && \
      $SUID $(which cp) -r $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose
  else
      sleep 5 ## wait time before next pull
      $SUID $(which mkdir) -p $DOCKER_CONFIG/cli-plugins && \
      $SUID $(which curl) -fsSL https://github.com/docker/compose/releases/download/$VERSION/docker-compose-linux-`$(uname -m)` -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
      $SUID $(which rm) -f /usr/bin/docker-compose /usr/local/bin/docker-compose && \
      $SUID $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose && \
      $SUID $(which cp) -r $DOCKER_CONFIG/cli-plugins/docker-compose /usr/bin/docker-compose && \
      $SUID $(which cp) -r $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose
  fi
}

function finalend() {
if test -f "/usr/bin/dockserver"; then
    $(which rm) /usr/bin/dockserver /bin/dockserver
fi
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

function SUID() {
if [[ $EUID != 0 ]]; then
   sudo "$1"
fi
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
