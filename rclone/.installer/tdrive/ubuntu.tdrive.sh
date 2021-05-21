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
basefolder="/opt/appdata"
  if [[ ! -x $(command -v docker) ]];then exit;fi
  if [[ ! -x $(command -v docker-compose) ]];then exit;fi
  if [[ -f "$basefolder/system/rclone/.env" ]];then $(command -v rm) -rf $basefolder/system/rclone/.env;fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Please wait while we pull the needed dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  $(command -v docker) system prune -af 1>/dev/null 2>&1
  pulls="ghcr.io/dockserver/docker-rclone:latest"
  for pull in ${pulls};do
     $(command -v docker) pull $pull --quiet
  done
  clear && checkfields && interface
done
}
checkfields() {
basefolder="/opt/appdata"
if [[ ! -d "$basefolder/system/rclone/" ]];then $(command -v mkdir) -p $basefolder/system/rclone/;fi
if [[ ! -f "$basefolder/system/rclone/.env" ]];then 
echo -n "\
#!/usr/bin/with-contenv bash
# shellcheck shell=bash
#####################################################################
# Copyright (c) 2021, dockserver                                    #
#####################################################################
# All rights reserved.                                              #
# started from Zero                                                 #
# Docker owned from dockserver                                      #
#####################################################################
DRIVE=tdrive
ACCOUNT=${ACCOUNT:-NOT-SET}
NAME=${NAME:-NOT-SET}
CLIENT_ID_FROM_GOOGLE=${CLIENT_ID_FROM_GOOGLE:-NOT-SET}
REFRESHTOKEN=${REFRESHTOKEN:-NOT-SET}
ACCESSTOKEN=${ACCESSTOKEN:-NOT-SET}
CLIENT_SECRET_FROM_GOOGLE=${CLIENT_SECRET_FROM_GOOGLE:-NOT-SET}
TDRIVE_ID=${TDRIVE_ID:-NOT-SET}" >$basefolder/system/rclone/.env
fi
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
      sed -i '' "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/rclone/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Validate your Google Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      $(command -v docker) run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk:alpine gcloud auth login --no-launch-browser --account=${ACCOUNTNAME}
   else
      sed -i "s/ACCOUNT=NOT-SET/ACCOUNT=$ACCOUNTNAME/g" $basefolder/system/rclone/.env
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
project() {
clear && interface
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Please Create a New Project

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       Please rype a name o the new Project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

   read -erp "Enter the Project Name: " PROJECT </dev/tty
if [[ $PROJECT != "" ]];then
   #for create project
   command=$($(command -v docker) run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk:alpine)
   $command gcloud config set project $PROJECT && $command gcloud projects create $PROJECT --name=$PROJECT && $command gcloud services enable drive.googleapis.com
else
  echo "You need to set a Project"
  project
fi
clear && interface
}
name() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Team Drive Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Team Drive Name: " TDNAME </dev/tty
if [[ $TDNAME != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/NAME=NOT-SET/NAME=$TDNAME/g" $basefolder/system/rclone/.env
   else
      sed -i "s/NAME=NOT-SET/NAME=$TDNAME/g" $basefolder/system/rclone/.env
   fi
else
  echo "Team Drive Name cannot be empty"
  name
fi
clear && interface
}
clientid() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Google Client ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Google Client ID: " CID </dev/tty
if [[ $CID != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/CLIENT_ID_FROM_GOOGLE=NOT-SET/CLIENT_ID_FROM_GOOGLE=$CID/g" $basefolder/system/rclone/.env
   else
      sed -i "s/CLIENT_ID_FROM_GOOGLE=NOT-SET/CLIENT_ID_FROM_GOOGLE=$CID/g" $basefolder/system/rclone/.env
   fi
else
  echo "Google Cliet ID cannot be empty"
  clientid
fi
clear && interface
}
clientsec() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Google Client Secret
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Google Client Secret: " CIDS </dev/tty
if [[ $CIDS != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/CLIENT_SECRET_FROM_GOOGLE=NOT-SET/CLIENT_SECRET_FROM_GOOGLE=$CIDS/g" $basefolder/system/rclone/.env
      atoken
   else
      sed -i "s/CLIENT_SECRET_FROM_GOOGLE=NOT-SET/CLIENT_SECRET_FROM_GOOGLE=$CIDS/g" $basefolder/system/rclone/.env
      atoken
   fi
else
  echo "Google Client Secret cannot be empty"
  clientsec
fi
clear && interface
}
atoken() {
source $basefolder/system/rclone/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Auth
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$CLIENT_ID_FROM_GOOGLE&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp '↘️  Token | PRESS [ENTER]: ' token </dev/tty
  if [[ $token != "" ]];then
     if [[ -f "/tmp/rclone.info" ]];then $(command -v rm) -rf /tmp/rclone.info;fi
        curl --request POST --data "code=$token&client_id=$CLIENT_ID_FROM_GOOGLE&client_secret=$CLIENT_SECRET_FROM_GOOGLE&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token >> $basefolder/system/rclone/.env
else
  echo "Token cannot be empty"
  atoken
fi
clear && interface
}
teamdriveid() {
basefolder="/opt/appdata"
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Team Drive ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
   read -erp "Enter your Team Drive ID: " TDID </dev/tty
if [[ $TDID != "" ]];then
   if [[ $(uname) == "Darwin" ]];then
      sed -i '' "s/TDRIVE_ID=NOT-SET/TDRIVE_ID=$TDID/g" $basefolder/system/rclone/.env
   else
      sed -i "s/TDRIVE_ID=NOT-SET/TDRIVE_ID=$TDID/g" $basefolder/system/rclone/.env
   fi
else
  echo "Google Client Secret cannot be empty"
  teamdriveid
fi
clear && interface
}
validauth() {
basefolder="/opt/appdata"
source $basefolder/system/rclone/.env
CLIENT_ID_FROM_GOOGLE=${CLIENT_ID_FROM_GOOGLE}
if [[ ${CLIENT_ID_FROM_GOOGLE} != "NOT-SET" ]];then
$(command -v docker) run --rm -v $basefolder/system/rclone:/system/rclone:rw ghcr.io/dockserver/docker-rclone:latest 1>/dev/null 2>&1
sleep 5 && clear 
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   SYSTEM MESSAGE: TDrive is added
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              Type confirm !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "Confirm Info | PRESS [ENTER] " input </dev/tty
  if [[ "$input" = "confirm" ]];then sleep 2 && clear && checkfields && interface;fi
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        ❌ ERROR - Not all parts are filled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 10 && clear && interface
fi
}
interface() {
basefolder="/opt/appdata"
source $basefolder/system/rclone/.env
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   Shared Drive  || UNENCRYPTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Account Details        [ ${ACCOUNT} ]
    [ 2 ] Create Google Project  [ ${PROJECT} }
    [ 3 ] Name of Shared Drive   [ ${NAME} ]
    [ 4 ] Cliemt ID              [ ${CLIENT_ID_FROM_GOOGLE} ]
    [ 5 ] Client Secret          [ ${CLIENT_SECRET_FROM_GOOGLE} ]
    [ 6 ] Team Drive ID          [ ${TDRIVE_ID} ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ D ] Deploy UNENCRYPTED Shared Drive

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ EXIT or Z ] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -erp "↘️  Type Number and Press [ENTER]: " headsectionun </dev/tty
  case $headsectionun in
    1) clear && account ;;
    2) clear && project ;;
    3) clear && name ;;
    4) clear && clientid ;;
    5) clear && clientsec ;;
    6) clear && teamdriveid ;;
    d|D) clear && validauth ;;
    Z|z|exit|EXIT|Exit|close) clear && exit ;;
    *) appstartup ;;
  esac
}
##
appstartup
#EOF