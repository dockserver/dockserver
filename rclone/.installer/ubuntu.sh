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
  if [[ ! -x $(command -v docker) ]];then exit;fi
  if [[ ! -x $(command -v docker-compose) ]];then exit;fi
  headinterface
done
}
headinterface() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Google Drive Section Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
           FYI ITS A PREALPHA VERSION !
 
    [ 1 ] GDRIVE                    ( not done yet )
    [ 2 ] TDRIVE                    ( ALPHA LEVEL )
    [ 3 ] GCRYPT                    ( not done yet )
    [ 4 ] TCRYPT                    ( ALPHA LEVEL )
    [ 5 ] RCLONE UNION              ( not done yet )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit || [ help or HELP ] - Help
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=gdrive && selection ;;
    2) clear && LOCATION=tdrive && selection ;;
    3) clear && LOCATION=gcrypt && selection ;;
    4) clear && LOCATION=tcrypt && selection ;;
    5) clear && LOCATION=union && selection ;;
    #help|HELP|Help) clear && sectionhelplayout ;;
    Z|z|exit|EXIT|Exit|close) exit ;;
    *) appstartup ;;
  esac
}
##
selection() {
#VALUES
LOCATION=${LOCATION}
case $(. /etc/os-release && echo "$ID") in
    ubuntu)     type="ubuntu" ;;
    debian)     type="ubuntu" ;;
    rasbian)    type="ubuntu" ;;
    *)          type='' ;;
esac
if [[ -f ./.installer/${LOCATION}/$type.${LOCATION}.sh ]];then bash ./.installer/${LOCATION}/$type.${LOCATION}.sh;fi
}
##
appstartup
#EOF