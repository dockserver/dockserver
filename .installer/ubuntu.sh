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
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
exit 0
fi
while true;do
  $(command -v apt) update -yqq && $(command -v apt) upgrade -yqq
  if [[ ! -x $(command -v docker) ]] && [[ ! -x $(command -v docker-compose) ]];then clear && LOCATION=preinstall && selection;fi
  if [[ -x $(command -v docker) ]] && [[ ! -x $(command -v docker-compose) ]];then revertcommand;fi
  if [[ -x $(command -v docker) ]] && [[ -x $(command -v docker-compose) ]];then clear && headinterface;fi
done
}
revertcommand() {
sudo apt install curl -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}

version() {
GUTHUB=dockserver
REPO=dockserver
VERSION=$(curl -sX GET https://api.github.com/repos/${GUTHUB}/${REPO}/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
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
version
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer    - Latest ${VERSION}
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
#"
