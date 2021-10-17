#!/usr/bin/with-contenv bash
# shellcheck shell=bash
######################################################
# Copyright (c) 2021, dockserver                     #
######################################################
# All rights reserved.                               #
# started from Zero                                  #
# Docker owned from dockserver                       #
# some codeparts are copyed from sagen from 88lex    #
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
#FUNCTIONS START
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
basefolder="/opt/appdata"
  if [[ ! -x $(command -v docker) ]];then exit;fi
  if [[ -f "$basefolder/system/mount/.env" ]];then $(command -v rm) -rf $basefolder/system/mount/.env;fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Please wait while we pull the needed dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  $(command -v docker) system prune -af 1>/dev/null 2>&1
  pulls="ghcr.io/dockserver/docker-gdsa:latest gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
  for pull in ${pulls};do
     $(command -v docker) pull $pull --quiet
  done
  clear && checkfields && interface
done
}
checkfields() {
basefolder="/opt/appdata"
if [[ ! -d "$basefolder/system/mount/" ]];then $(command -v mkdir) -p $basefolder/system/mount/;fi
if [[ ! -d "$basefolder/system/mount/keys" ]];then $(command -v mkdir) -p $basefolder/system/mount/keys;fi
if [[ ! -d "$basefolder/system/mount/" ]];then $(command -v mkdir) -p $basefolder/system/mount/;fi
if [[ ! -f "$basefolder/system/mount/.env" ]];then
echo -n "\
#!/usr/bin/with-contenv bash
# shellcheck shell=bash
#####################################################################
# Copyright (c) 2021, dockserver                                    #
#####################################################################
# All rights reserved.                                              #
# started from Zero                                                 #
# Docker owned from dockserver                                      #
# some codeparts are copyed from sagen from 88lex                   #
# sagen is under MIT License                                        #
# Copyright (c) 2019 88lex                                          #
#####################################################################
ACCOUNT=${ACCOUNT:-NOT-SET}
GROUP_NAME=${GROUPNAME:-NOT-SET}
PROJECT_BASE_NAME=${PROJECT:-NOT-SET}" >$basefolder/system/mount/.env
fi
}
projectname() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Project Name

         min is 6 chars
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Projectname: " PROJECTNAME </dev/tty
   if [[ $(echo $PROJECTNAME | wc -m) -le "6" || $(echo $PROJECTNAME | wc -m) -ge "16" ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Sorry the minimum of chars are 6 and maximum is 16
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   sleep 5 && projectname
fi
if [[ $PROJECTNAME != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/PROJECT_BASE_NAME=NOT-SET/PROJECT=$PROJECTNAME/g" $basefolder/system/mount/.env
   else
      sed -i "s/PROJECT_BASE_NAME=NOT-SET/PROJECT=$PROJECTNAME/g" $basefolder/system/mount/.env
   fi
else
  echo "Project Name cannot be empty"
  projectname
fi
clear && interface
}
groupname() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   GROUPNAME

         min is 4 chars
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Projectname: " GROUPNAME </dev/tty
   if [[ $(echo $GROUPNAME | wc -m) -le "4" || $(echo $GROUPNAME | wc -m) -ge "12" ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Sorry the minimum of chars are 4 and maximum is 16
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   sleep 5 && groupname
fi
if [[ $GROUPNAME != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/GROUP_NAME=NOT-SET/GROUP_NAME=$GROUPNAME/g" $basefolder/system/mount/.env
   else
      sed -i "s/GROUP_NAME=NOT-SET/GROUP_NAME=$GROUPNAME/g" $basefolder/system/mount/.env
   fi
else
  echo "Project Name cannot be empty"
  groupname
fi
clear && interface
}
account() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Account Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Account Email: " ACCOUNTNAME </dev/tty
if [[ $ACCOUNTNAME != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/mount/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Validate your Google Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      $(command -v docker) run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk:alpine gcloud auth login --no-launch-browser --account=${ACCOUNTNAME}
   else
      sed -i "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/mount/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Validate your Google Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      $(command -v docker) run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk:alpine gcloud auth login --no-launch-browser --account=${ACCOUNTNAME}
   fi
else
  echo "Account name cannot be empty"
  account
fi
clear && interface
}
validauth() {
basefolder="/opt/appdata"
source $basefolder/system/mount/.env
ACCOUNT=${ACCOUNT}
if [[ ${ACCOUNT} != "NOT-SET" ]];then
if [[ -d "$basefolder/system/mount/keys" ]];then $(command -v rm) -rf $basefolder/system/mount/keys;fi
if [[ ! -d "$basefolder/system/mount/keys" ]];then $(command -v mkdir) -p $basefolder/system/mount/keys;fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        🚀   Google Service Key running now
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
$(command -v docker) run --rm --volumes-from gcloud-config -v $basefolder/system/mount:/system/mount:rw ghcr.io/dockserver/docker-gdsa:latest
sleep 5 && clear
members=$(cat $basefolder/system/mount/members.csv)
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   SYSTEM MESSAGE: Key Generation Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Type confirm ! when all is done !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "Confirm Info | PRESS [ENTER] " input </dev/tty
  if [[ "$input" = "confirm" ]];then sleep 2 && clear && restupper && checkfields && interface;fi
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR ->  Account is ${ACCOUNT}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 10 && clear && interface
fi
}
restupper() {
section=system
typed=uploader
compose="compose/docker-compose.yml"
appfolder="/opt/dockserver/apps"
basefolder="/opt/appdata"
uploader=$($(command -v docker) ps -aq --format={{.Names}} | grep -x 'uploader')
if [[ ${uploader} == ${typed} ]];then
   $(command -v docker) image prune -af 1>/dev/null 2>&1
   if [[ ! -d $basefolder/system/uploader/ ]];then $(command -v mkdir) -p $basefolder/system/${typed};fi
   if [[ ! -d $basefolder/system/uploader/.keys ]];then $(command -v mkdir) -p $basefolder/system/${typed}/.keys;fi
      $(command -v echo) "0" > $basefolder/system/${typed}/.keys/usedupload
      $(command -v echo) "0" > $basefolder/system/${typed}/.keys/lasteservicekey
      $(command -v rsync) $appfolder/${section}/compose/${typed}.yml $basefolder/$compose -aqhv
   if [[ -f $basefolder/$compose ]];then
       $(command -v cd) $basefolder/compose/
       $(command -v docker-compose) config 1>/dev/null 2>&1
       errorcode=$?
       if [[ $errorcode -ne 0 ]];then
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR
    Compose check of ${typed} has failed
    Return code is ${errorcode}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
  clear && interface
     else
       composer=$(command -v docker-compose)
       for i in ${composer};do
          $i down ${typed} 1>/dev/null 2>&1
          $i rm ${typed} 1>/dev/null 2>&1
          $i pull ${typed} 1>/dev/null 2>&1
          $i up -d --force-recreate 1>/dev/null 2>&1
       done
     fi
  fi
fi

if [[ $(whoami) == "root" ]];then $(command -v chown) -hR 1000:1000 $basefolder/system;fi
if [[ $(whoami) != "root" ]];then $(command -v chown) -hR $(whoami):$(whoami) $basefolder/system;fi
}
interface() {
source $basefolder/system/mount/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Google Service Key Builder  || ENCRYPTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Account Details            [ ${ACCOUNT} ]
    [ 2 ] Service Account Name       [ ${SANAME} ]
    [ 3 ] Project Name               [ ${PROJECT} ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ D ] Deploy Service Keys for mounting

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ EXIT or Z ] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type Number and Press [ENTER]: " headsectionen </dev/tty
  case $headsectionen in
    1) clear && account ;;
    2) clear && sabasename ;;
    3) clear && projectname ;;
    d|D) clear && validauth ;;
    Z|z|exit|EXIT|Exit|close) clear && exit ;;
    *) appstartup ;;
  esac
}
appstartup
