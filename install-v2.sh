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
function progress() {
  $(which echo) && \
    $(which echo) -e "\e[1;31m[RUN NOW]\e[0m \e[1m$1\e[0m"
}
function rmdocker() {
   if [ $(which docker) ]; then
      dockers=$($(which docker) ps -aq --format '{{.Names}}' | sed '/^$/d' | grep 'dockserver')
        $(which docker) stop $dockers &>/dev/null
          $(which docker) rm $dockers &>/dev/null
            $(which docker) system prune -af &>/dev/null
       unset dockers
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
   case "$distribution" in
      ubuntu|debian|rasbian) upsysubu && dockinst && dockcomp && makefolder ;;
      ##*) upsysanother ;;
      *) progress 'You are using an unsupported operating system.' && sleep 10 && exit 0 ;;
   esac
}
function upsysubu() {
   progress "**** update system ****"
     updates="update upgrade autoremove autoclean"
       for upp in ${updates}; do $(which apt) $upp -yqq &>/dev/null && clear; done
   progress "**** install build packages ****"
     packages="curl wget jq tzdata rsync"
       $(which apt) $packages -yqq &>/dev/null
   progress "**** remove old links  ****"
     remove="/bin/dockserver /usr/bin/dockserver"
       $(which rm) -rf $remove &>/dev/null
       if [ $(which snapd) ]; then
          progress "**** snapd  ****" && \
          if [[ -d "/var/cache/snapd/" ]]; then $(which rm) -rf /var/cache/snapd/;fi
             $(which apt) autoremove --purge snapd gnome-software-plugin-snap -yqq && \
               $(which apt) autoclean -yqq
          fi
   unset packages remove updates
}
function upsysanother() {
    progress "not done yet"
}
function dockinst() {
if [ ! $(which docker) ]; then
   progress "**** installing now docker ****" && \
     $(which curl) https://get.docker.com | sh &>/dev/null && \
       $(which systemctl) --now enable docker &>/dev/null
fi
$(which echo) -e '{
    "storage-driver": "overlay2",
    "userland-proxy": false,
    "dns": ["8.8.8.8", "1.1.1.1"],
    "ipv6": false,
    "log-driver": "json-file",
    "live-restore": true,
    "log-opts": {"max-size": "8m", "max-file": "2"}
}' >/etc/docker/daemon.json

$(which usermod) -aG docker $(whoami)
  $(which systemctl) reload-or-restart docker.service &>/dev/null && \
    $(which systemctl) enable docker.service &>/dev/null
      $(which curl) --silent -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | bash &>/dev/null
        $(which docker) volume create -d local-persist -o mountpoint=/mnt --name=unionfs && \
          $(which docker) network create --driver=bridge proxy &>/dev/null
}

function dockcomp() {
export DOCKER_CONFIG=${DOCKER_CONFIG:-/opt/appdata/.docker}
VERSION="$($(which curl) -sX GET https://api.github.com/repos/docker/compose/releases/latest | jq --raw-output '.tag_name')"
ARCH=$(uname -m)
if [ ! -f "$DOCKER_CONFIG/cli-plugins/docker-compose" ]; then
   progress "**** installing now docker composer $VERSION on $ARCH ****" && \
   $(which mkdir) -p $DOCKER_CONFIG/cli-plugins && \
     $(which curl) -fsSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-linux-${ARCH}" -o $DOCKER_CONFIG/cli-plugins/docker-compose
     if test -f $DOCKER_CONFIG/cli-plugins/docker-compose;then
        $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose && \
          $(which ln) -sf $DOCKER_CONFIG/cli-plugins/docker-compose /usr/bin/docker-compose
     else
        sleep 5 ## wait time before next pull
          $(which mkdir) -p $DOCKER_CONFIG/cli-plugins && \
            $(which curl) -fsSL https://github.com/docker/compose/releases/download/$VERSION/docker-compose-linux-`$(uname -m)` -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
              $(which chmod) +x $DOCKER_CONFIG/cli-plugins/docker-compose && \
                $(which ln) -sf $DOCKER_CONFIG/cli-plugins/docker-compose /usr/bin/docker-compose
     fi
fi

## THX to @sdr-enthusiasts/kx1t
## Add some aliases to localhost in `/etc/hosts`. 
## This will speed up recreation of images with docker-compose
if ! grep localunixsocket /etc/hosts >/dev/null 2>&1; then
  progress "*** Speeding up the recreation of containers when using docker-compose... ***" && \
    $(which sed) -i 's/^\(127.0.0.1\s*localhost\)\(.*\)/\1\2 localunixsocket localunixsocket.local localunixsocket.home/g' /etc/hosts
fi
}
function makefolder() {
folder="/mnt"
  $(which mkdir) -p \
    $folder/{unionfs,downloads,incomplete,torrent,nzb} \
      $folder/{incomplete,downloads}/{nzb,torrent}/{complete,temp,movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux,watch} \
        $folder/downloads/torrent/{temp,complete}/{movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux}
basefolder="/opt/appdata"
  $(which mkdir) -p $basefolder/{compose,system,traefik,authelia} && \
    $(which find) $basefolder -exec $(command -v chmod) a=rx,u+w {} \; && \
      $(which find) $basefolder -exec $(command -v chown) -hR 1000:1000 {} \; && \
        $(which find) $folder -exec $(which chmod) a=rx,u+w {} \; && \
          $(which find) $folder -exec $(which chown) -hR 1000:1000 {} \;
}
function finalend() {
if test -f "/usr/bin/dockserver";then $(which rm) /usr/bin/dockserver;fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/dockserver && \
      $(which usermod) -aG sudo $(whoami) && \
        $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver && \
          $(which ln) -sf /usr/bin/dockserver /bin/dockserver && \
            $(which chmod) a+x /usr/bin/dockserver && \
              $(which chown) $(whoami):$(whoami) /usr/bin/dockserver
else
    $(which chown) -R 1000:1000 /opt/dockserver && \
      $(which cp) /opt/dockserver/.installer/dockserver /usr/bin/dockserver && \
        $(which ln) -sf /usr/bin/dockserver /bin/dockserver && \
          $(which chmod) a+x /usr/bin/dockserver && \
            $(which chown) -R 1000:1000 /usr/bin/dockserver
fi

## Add PROXY socket option when user want int
## fallback when it's not running
installed=$($(which docker) ps -aq --format '{{.Names}}' | grep -x '*socket-proxy*')
if [[ $installed == "" ]]; then
   DOCKER_HOST=/var/run/docker.sock
else
   DOCKER_HOST='tcp://localhost:2375'
fi
basefolder="/opt/appdata"
## pull and execute initial image
  $(which docker) pull -q ghcr.io/dockserver/docker-create:latest && \
  $(which docker) run -it --rm \
    --name dockserver-create \
    -v $basefolder:$basefolder \
    -v $DOCKER_HOST:$DOCKER_HOST \
    docker.dockserver.io/dockserver/docker-create:latest && clear

## wait until create is done ##
DOMAIN=$($(which cat) $basefolder/compose/.env | $(which grep) "DOMAIN" | $(which tail) -n1 | $(which awk) -F"=" '{print $2}')
if ! grep $DOMAIN /etc/hosts >/dev/null 2>&1; then
  progress "*** Adding $DOMAIN to /etc/hosts.... ***" && \
    $(which echo) "127.0.0.1 *.$DOMAIN $DOMAIN" | $(which tee) -a /etc/hosts > /dev/null
fi
check=$($(which docker) ps -aq --format '{{.Names}}' | $(which grep) -x 'traefik')
if [[ $check == "" ]]; then
   RUN=$($(which) curl) -fsSL http://whatismijnip.nl | $(which cut) -d " " -f 5)
     FINAL=$($(which echo) http://$RUN:5000)
else
   RUN=$($(which cat) /opt/appdata/compose/.env | $(which grep) "DOMAIN" | $(which tail) -n1 | $(which awk) -F"=" '{print $2}')
     FINAL=$($(which echo) https://ui.$RUN)
fi
progress "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    to run the first install :
    dockserver webui : ${FINAL}

    from the dockserver-ui you can deploy the rest

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
### RUN FROM HERE ###
checksys
if [[ "$(systemd-detect-virt)" == "lxc" ]]; then
   $(which curl) --silent -fsSl https://raw.githubusercontent.com/dockserver/dockserver/master/scripts/lxc/lxc.sh -o /tmp/lxcscript.sh && \
     $(which bash) /tmp/lxcscript.sh
fi
[[ ! -d "/opt/dockserver" ]] && $(which mkdir) -p /opt/dockserver
dockserver=/opt/dockserver
while true; do
   if [ "$($(which ls) -1p $dockserver)" ]; then
      rmdocker && sleep 3 && break
   else
      pulldockserver && \
        progress "**** dockserver is not pulled yet ****" && \
          progress "**** this could take some time ****" && \
            sleep 5 && continue
   fi
done
## RUN COMMAND ##
finalend
#EOF#
