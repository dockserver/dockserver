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
while true;do
     dockertraefik=$(docker ps -a --format '{{.Names}}' | sed '/^$/d' | grep -E 'traefik')
     ntdocker=$(docker network ls | grep -E 'proxy')
  if [[ $ntdocker == "" && $dockertraefik == "" ]]; then
     unset ntdocker && unset dockertraefik
     clear && LOCATION=preinstall && selection
  else
     unset ntdocker && unset dockertraefik
     clear && headinterface
  fi
done
}

updatebin() {
file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
store2=/usr/bin/dockserver
if [[ -f "/bin/dockserver" ]];then
   $(command -v rm) $store && \
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

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    [ 1 ] DockServer - Traefik + Authelia
    [ 2 ] DockServer - Applications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=traefik && selection ;;
    2) clear && LOCATION=apps && selection ;;
    Z|z|exit|EXIT|Exit|close) updatebin && exit ;;
    *) clear && appstartup ;;
  esac
}
appstartup
#E-o-F#
