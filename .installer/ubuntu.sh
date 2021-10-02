#!/usr/bin/with-contenv bash
# shellcheck shell=bash
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
# shellcheck disable=SC2086
# shellcheck disable=SC2006
appstartup() {
if [[ $EUID -ne 0 ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit 0
fi
while true;do
  $(command -v apt) update -yqq && $(command -v apt) upgrade -yqq
  if [[ ! -x $(command -v docker) ]] && [[ ! -x $(which docker compose) ]];then clear && LOCATION=preinstall && selection;fi
  if [[ $(which docker) ]] && [[ `docker compose version` != "" ]];then clear && headinterface;fi
done
}
updatecompose() {
   COMPOSE_VERSION=$($(command -v curl) --silent -fsSL https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
   ARCH=$(command arch)
   DIST="$(uname -s)"
   if [ "${DIST}" = "Linux" ]; then 
      DIST="linux"
   elif [ "${DIST}" = "Darwin" ]; then 
      DIST="darwin" 
   else
      echo "**** Unsupported Linux architecture ${ARCH} found, exiting... ****" && sleep 30 && exit 1
   fi
   if [[ $(which docker-compose) ]]; then
      rm -f /usr/local/bin/docker-compose /usr/bin/docker-compose
      curl --silent -fL https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh
   else
     DCTEST=$(docker compose version| awk $'{print $4}')
     if [ ${DCTEST} == "" ] || [ ${DCTEST} != "" ]; then 
        if [[ -f ~/.docker/cli-plugins/docker-compose ]]; then rm -f ~/.docker/cli-plugins/docker-compose;fi
        mkdir -p ~/.docker/cli-plugins/
        curl --silent -SL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${ARCH} -o ~/.docker/cli-plugins/docker-compose 
        chmod +x ~/.docker/cli-plugins/docker-compose
     fi
   fi
}
updatebin() {
file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
store2=/usr/bin/dockserver
if [[ -f "/bin/dockserver" ]];then
   $(command -v rm) $store
   $(command -v rsync) $file $store -aqhv
   $(command -v rsync) $file $store2 -aqhv
   $(command -v chown) -R 1000:1000 $store $store2
   $(command -v chmod) -R 755 $store $store2
fi
}
selection() {
LOCATION=${LOCATION}
cd /opt/dockserver/${LOCATION} && $(command -v bash) install.sh
}
headinterface() {
updatecompose
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] DockServer - Traefik + Authelia
    [ 2 ] DockServer - Applications
    [ 3 ] DockServer - Google Service Key Builder
    [ 4 ] DockServer - Rclone Builder

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=traefik && selection ;;
    2) clear && LOCATION=apps && selection ;;
    3) clear && LOCATION=gdsa && selection ;;
    4) clear && LOCATION=rclone && selection ;;
    Z|z|exit|EXIT|Exit|close) updatebin && exit ;;
    *) clear && appstartup ;;
  esac
}
appstartup
#EOF
