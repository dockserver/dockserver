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
  if [[ -f "$basefolder/system/servicekeys/.env" ]];then $(command -v rm) -rf $basefolder/system/servicekeys/.env;fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Please wait while we pull the needed dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  $(command -v docker) system prune -af 1>/dev/null 2>&1
  pulls="ghcr.io/dockserver/docker-gdsa:latest  rclone/rclone gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
  for pull in ${pulls};do
     $(command -v docker) pull $pull --quiet
  done
  clear && checkfields && interface
done
}
checkfields() {
basefolder="/opt/appdata"
if [[ ! -d "$basefolder/system/servicekeys/" ]];then $(command -v mkdir) -p $basefolder/system/servicekeys/;fi
if [[ ! -f "$basefolder/system/servicekeys/.env" ]];then
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
ENCRYPT=TRUE
PASSWORD=${PASSWORD:-NOT-SET}
SALT=${SALT:-NOT-SET}" >$basefolder/system/servicekeys/.env
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
      sed -i '' "s/PROJECT=NOT-SET/PROJECT=$PROJECTNAME/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/PROJECT=NOT-SET/PROJECT=$PROJECTNAME/g" $basefolder/system/servicekeys/.env
   fi
else
  echo "Project Name cannot be empty"
  projectname
fi
clear && interface
}
sabasename() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Service Account Name

         min is 6 chars
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Service Account Name: " SABASENAME </dev/tty
   if [[ $(echo $SABASENAME | wc -m) -le "6" || $(echo $SABASENAME | wc -m) -ge "16" ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Sorry the minimum of chars are 6 and maximum is 16
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   sleep 5 && sabasename
fi
if [[ $SABASENAME != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/SANAME=NOT-SET/SANAME=$SABASENAME/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/SANAME=NOT-SET/SANAME=$SABASENAME/g" $basefolder/system/servicekeys/.env
   fi
else
  echo " Service Account Base name cannot be empty"
  sabasename
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
      sed -i '' "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/servicekeys/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Validate your Google Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      $(command -v docker) run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk:alpine gcloud auth login --no-launch-browser --account=${ACCOUNTNAME}
   else
      sed -i "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/servicekeys/.env
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
teamdriveid() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Team Drive ID

    https://drive.google.com/drive/u/1/shared-drives

    Click on the Shared Drive !

    In the Link its shows behind /folders/<ID HERE>
    The Shared Drive ID !!

    Please dont use the name of the Shared Drive

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Team Drive ID: " TEAMDRVEID </dev/tty
if [[ $TEAMDRVEID != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/TEAMDRIVEID=NOT-SET/TEAMDRIVEID=$TEAMDRVEID/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/TEAMDRIVEID=NOT-SET/TEAMDRIVEID=$TEAMDRVEID/g" $basefolder/system/servicekeys/.env
   fi
else
  echo "Team Drive ID name cannot be empty"
  teamdriveid
fi
clear && interface
}
servicekeysnumber() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Google Service Keys
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp '↘️  Type a Number [ 4 thru 60 ] | Press [ENTER]: ' KEYS </dev/tty
if [[ $KEYS -le "3" || $KEYS -ge "60" ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Sorry $KEYS is more then 60 or less than 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 5 && servicekeysnumber
fi
if [[ $KEYS -ge "3" || $KEYS -le "60" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/NUMGDSAS=NOT-SET/NUMGDSAS=$KEYS/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/NUMGDSAS=NOT-SET/NUMGDSAS=$KEYS/g" $basefolder/system/servicekeys/.env
   fi
fi
clear && interface
}
rcpassword() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   rclone Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your rclone Password: " PASSWORD </dev/tty
if [[ $PASSWORD != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
   $(command -v docker) pull rclone/rclone -q > /dev/null
      sed -i '' "s/PASSWORD=NOT-SET/PASSWORD=$($(command -v docker) run rclone/rclone obscure ${PASSWORD} | tail -n1)/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/PASSWORD=NOT-SET/PASSWORD=$($(command -v docker) run rclone/rclone obscure ${PASSWORD} | tail -n1)/g" $basefolder/system/servicekeys/.env
   fi
else
  echo "rclone Password cannot be empty"
  rcpassword
fi
clear && interface
}
rcsalt() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   rclone Salt Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your rclone Saltpassword: " SALT </dev/tty
if [[ $SALT != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/SALT=NOT-SET/SALT=$($(command -v docker) run rclone/rclone obscure ${SALT} | tail -n1)/g" $basefolder/system/servicekeys/.env
   else
      sed -i "s/SALT=NOT-SET/SALT=$($(command -v docker) run rclone/rclone obscure ${SALT} | tail -n1)/g" $basefolder/system/servicekeys/.env
   fi
else
  echo "Salt Password cannot be empty"
  rcsalt
fi
clear && interface
}
validauth() {
basefolder="/opt/appdata"
source $basefolder/system/servicekeys/.env
ACCOUNT=${ACCOUNT}
if [[ ${ACCOUNT} != "NOT-SET" ]];then
if [[ -d "$basefolder/system/servicekeys/keys" ]];then $(command -v rm) -rf $basefolder/system/servicekeys/keys;fi
if [[ ! -d "$basefolder/system/servicekeys/keys" ]];then $(command -v mkdir) -p $basefolder/system/servicekeys/keys;fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        🚀   Google Service Key running now
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
$(command -v docker) run --rm --volumes-from gcloud-config -v $basefolder/system/servicekeys:/system/servicekeys:rw ghcr.io/dockserver/docker-gdsa:latest
sleep 5 && clear
members=$(cat $basefolder/system/servicekeys/members.csv)
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   SYSTEM MESSAGE: Key Generation Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

${members}

    Shortcut to Google Team Drives
    Share the E-Mails with the CORRECT TEAMDRIVE: ${TEAMDRIVEID}
    SAVE TIME! Copy & Paste the all the E-Mails into the share!

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
source $basefolder/system/servicekeys/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Google Service Key Builder  || ENCRYPTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Account Details            [ ${ACCOUNT} ]
    [ 2 ] Service Account Name       [ ${SANAME} ]
    [ 3 ] Project Name               [ ${PROJECT} ]
    [ 4 ] Team Drive ID              [ ${TEAMDRIVEID} ]
    [ 5 ] Numbers of service Keys    [ ${NUMGDSAS} ]
    [ 6 ] rclone Password            [ ${PASSWORD} ]
    [ 7 ] rclone salt password       [ ${SALT} ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ D ] Deploy ENCRYPTED Service Keys

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ EXIT or Z ] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type Number and Press [ENTER]: " headsectionen </dev/tty
  case $headsectionen in
    1) clear && account ;;
    2) clear && sabasename ;;
    3) clear && projectname ;;
    4) clear && teamdriveid ;;
    5) clear && servicekeysnumber ;;
    6) clear && rcpassword ;;
    7) clear && rcsalt ;;
    d|D) clear && validauth ;;
    Z|z|exit|EXIT|Exit|close) clear && exit ;;
    *) appstartup ;;
  esac
}
appstartup
