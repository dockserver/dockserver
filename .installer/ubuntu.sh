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
while true; do
  $(command -v apt) update -yqq && $(command -v apt) upgrade -yqq
  clear && headinterface
done
}
selection() {
LOCATION=${LOCATION}
cd /opt/dockserver/${LOCATION} && $(command -v bash) install.sh
}
headinterface() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer Head Installer [ EASY MODE ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    [ 1 ] DockServer - Preinstallation
    [ 2 ] DockServer - Traefik + Authelia
    [ 3 ] DockServer - Applications
    [ 4 ] DockServer - Google Service Key Builder
    [ 5 ] DockServer - Rclone Builder [ ALPHA ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=preinstall && selection ;;
    2) clear && LOCATION=traefik && selection ;;
    3) clear && LOCATION=apps && selection ;;
    4) clear && LOCATION=gdsa && selection ;;
    5) clear && LOCATION=rclone && selection ;;
    #help|HELP|Help) clear && sectionhelplayout ;;
    Z|z|exit|EXIT|Exit|close) exit ;;
    *) clear && appstartup ;;
  esac
}
##########
appstartup
