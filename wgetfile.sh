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
   dockers=$($(which docker) ps -aq --format '{{.Names}}' | sed '/^$/d' | grep 'dockserver')
     $(which docker) stop $dockers &>/dev/null
       $(which docker) rm $dockers &>/dev/null
         $(which docker) system prune -af &>/dev/null
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

function checksys() {
   distribution=$(. /etc/os-release;echo $ID)
   case "$(distribution)" in
      ubuntu|debian|rasbian) upsysubu && dockinst && dockcomp ;;
      ##*) upsysanother ;;
      *) echo 'You are using an unsupported operating system.' && sleep 10 && exit 0 ;;
   esac
}

function upsysubu() {
   log "**** update system ****"
      updates="update upgrade autoremove autoclean"
      for upp in ${updates}; do $(which apt) $upp -yqq &>/dev/null && clear; done
   log "**** install build packages ****"
      packages="curl wget jq tzdata rsync"
      $(which apt) $packages -yqq &>/dev/null
   log "**** remove old links  ****"
      remove="/bin/dockserver /usr/bin/dockserver"
      $(which rm) -rf $remove &>/dev/null
      if [ $(which snapd) ]; then
         log "**** snapd  ****" && \
         if [[ -d "/var/cache/snapd/" ]]; then $(which rm) -rf /var/cache/snapd/;fi
         $(which apt) autoremove --purge snapd gnome-software-plugin-snap -yqq && \
         $(which apt) autoclean -yqq
      fi
   unset packages remove updates
}

function upsysanother() {
    echo "not done yet"
}

function dockinst() {

if [ ! $(which docker) ]; then
   log "**** installing now docker ****" && \
     $(which curl) https://get.docker.com | sh &>/dev/null && \
       $(which systemctl) --now enable docker &>/dev/null && \
         $(which systemctl) reload-or-restart docker.service
fi
}

function dockcomp() {

if [ ! $($(which docker) compose version) ]; then
   log "**** installing now docker composer v2 ****" && \
   VERSION="$($(which curl) -sX GET https://api.github.com/repos/docker/compose/releases/latest | jq --raw-output '.tag_name')"
   DOCKER_CONFIG=${DOCKER_CONFIG:-/opt/appdata/.docker}
     $(which mkdir) -p $DOCKER_CONFIG/cli-plugins && \
       $(which curl) -SL https://github.com/docker/compose/releases/download/$VERSION/docker-compose-linux-`$(uname -m)` -o $DOCKER_CONFIG/cli-plugins/docker-compose
       if test -f $DOCKER_CONFIG/cli-plugins/docker-compose;then
          $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose
       else
          sleep 5 ## wait time before next pull
            $(which mkdir) -p $DOCKER_CONFIG/cli-plugins && \
              $(which curl) -SL https://github.com/docker/compose/releases/download/$VERSION/docker-compose-linux-`$(uname -m)` -o $DOCKER_CONFIG/cli-plugins/docker-compose
                $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose
       fi
fi
}

function finalend() {

if test -f "/usr/bin/dockserver";then $(which rm) /usr/bin/dockserver;fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/dockserver
      $(which usermod) -aG sudo $(whoami)
        $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver
          $(which ln) -sf /usr/bin/dockserver /bin/dockserver
            $(which chmod) a+x /usr/bin/dockserver
              $(which chown) $(whoami):$(whoami) /usr/bin/dockserver 
else 
    $(which chown) -R 1000:1000 /opt/dockserver
      $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver
        $(which ln) -sf /usr/bin/dockserver /bin/dockserver
          $(which chmod) a+x /usr/bin/dockserver
            $(which chown) -R 1000:1000 /usr/bin/dockserver
fi

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     run dockserver docker
     [ sudo ] dockserver -i

     all commands
     [ sudo ] dockserver -h / --help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
" 
}

checksys

[[ ! -d "/opt/dockserver" ]] && $(which mkdir) -p /opt/{dockserver,appdata,compose}

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
