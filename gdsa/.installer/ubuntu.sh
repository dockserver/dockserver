#!/usr/bin/with-contenv bash
# shellcheck shell=bash
######################################################
# Copyright (c) 2021, dockserver                     #
######################################################
# All rights reserved.                               #
# Started from Zero                                  #
# Docker owned by dockserver                         #
# some codeparts are copyed from sagen by 88lex      #
# sagen is under MIT License                         #
# Copyright (c) 2019 88lex                           #
#                                                    #
# CREDITS: The scripts and methods are based on      #
# ideas/code/tools from ncw, max, sk, rxwatcher,     #
# l3uddz, zenjabba, dashlt, mc2squared, storm,       #
# physk , plexguide and all missed once              #
######################################################
# shellcheck disable=SC2003
# shellcheck disable=SC2006
# shellcheck disable=SC2207
# shellcheck disable=SC2012
# shellcheck disable=SC2086
# shellcheck disable=SC2196
# shellcheck disable=SC2046
# shellcheck disable=SC1091
appstartup() {
if [[ $EUID -ne 0 ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit
fi
while true; do
  if [[ ! -x $(command -v docker) ]];then exit;fi
  clear && checkfields && interface
done
}
checkfields() {
basefolder="/opt/appdata"
if [[ ! -d "$basefolder/GDSA/" ]];then $(command -v rm) -rf $basefolder/GDSA/;fi
if [[ ! -d "$basefolder/system/servicekeys/" ]];then $(command -v mkdir) -p $basefolder/system/servicekeys/;fi
if [[ ! -d "$basefolder/system/servicekeys/keys" ]];then $(command -v mkdir) -p $basefolder/system/servicekeys/keys;fi
if [[ ! -f "$basefolder/system/servicekeys/.env" ]];then 
echo -n "\
#!/usr/bin/with-contenv bash
# shellcheck shell=bash
#####################################################################
# Copyright (c) 2021, dockserver                                    #
#####################################################################
# All rights reserved.                                              #
# started from Zero                                                 #
# Docker owned by dockserver                                        #
# some codeparts are copyed from sagen by 88lex                     #
# sagen is under MIT License                                        #
# Copyright (c) 2019 88lex                                          #
#####################################################################
CYCLEDELAY=0.1s
SANAME=${SANAME:-NOT-SET}
FIRSTGDSA=1
LASTPROJECTNUM=1
NUMGDSAS=${NUMGDSAS:-NOT-SET}
PROGNAME=${PROGNAME:-NOT-SET}
SECTION_DELAY=5
#### USER VALUES ####
ACCOUNT=${ACCOUNT:-NOT-SET}
PROJECT=${PROJECT:-NOT-SET}
TEAMDRIVEID=${TEAMDRIVEID:-NOT-SET}
ENCRYPT=${ENCRYPT:-FALSE}
PASSWORD=${PASSWORD:-FALSE}
SALT=${SALTPASSWORD:-FALSE}" >$basefolder/system/servicekeys/.env
fi
}
forcereset() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   ServiceKey.env force reset
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ R ] Remove ServiceKey.env File

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit || [ help or HELP ] - Help
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type R|r and Press [ENTER]: " headsectionforce </dev/tty
  case $headsectionforce in
    R|r|remove|y|Y) clear && remove ;;
    help|HELP|Help) clear && LOCATION=help && selection ;;
    Z|z|exit|EXIT|Exit|close) clear && interface ;;
    *) appstartup ;;
  esac
}
remove() {
basefolder="/opt/appdata"
if [[ -f "$basefolder/system/servicekeys/.env" ]];then 
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   ServiceKey.env force reset
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    ServiceKey.env File Removed! || Force Reset

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
$(command -v rm) -rf $basefolder/system/servicekeys/.env && sleep 5 && clear && checkfields && interface
else 
   notfound
fi
}
notfound() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   servicekeys.env force reset
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    Sorry we could not find the servicekeys.env file. 
    No force reset was done !

    Type Confirm !

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "Confirm Info | PRESS [ENTER] " input </dev/tty
  if [[ "$input" = "confirm" ]];then sleep 4 && clear && checkfields && interface; else notfound;fi
}
selection() {
LOCATION=${LOCATION}
case $(. /etc/os-release && echo "$ID") in
    ubuntu)     type="ubuntu" ;;
    debian)     type="ubuntu" ;;
    rasbian)    type="ubuntu" ;;
    *)          type='' ;;
esac
if [[ -f ./.installer/.${LOCATION}/$type.${LOCATION}.sh ]];then bash ./.installer/.${LOCATION}/$type.${LOCATION}.sh;fi
}
interface() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   ServiceKey Head Section Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Google ServiceKey Builder   || UNENCRYPTED
    [ 2 ] Google ServiceKey Builder   || ENCRYPTED
    [ 3 ] Remove ServiceKey.env       || Force Reset

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit || [ help or HELP ] - Help
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=case1 && selection ;;
    2) clear && LOCATION=case2 && selection;;
    3) clear && forcereset ;;
    help|HELP|Help) clear && LOCATION=help && selection ;;
    Z|z|exit|EXIT|Exit|close) exit ;;
    *) appstartup ;;
  esac
}
appstartup
#EOF