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
basefolder="/opt/appdata"
plex=$(docker ps -a --format={{.Names}} | grep -x 'plex' 1>/dev/null 2>&1 && echo true || echo false)
if [[ -d "/opt/appdata/plex/" && $plex == "true" ]]; then
SERVERIP=$(curl -s http://whatismijnip.nl |cut -d " " -f 5)
token=$(cat "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
source $basefolder/compose/.env

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
In Plex-Utils
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Navigate to Config Page: https://plex-utills.${DOMAIN}/config
  
  Plex Connection
- Enter Plex Url : http://${SERVERIP}:32400
- Enter Plex Token : ${token}

  Libraries
- Enter Library Names ( Must match Plex Library Names )

  Schedules
- Set Schedules ( These must be Set, even If you disable a script )

  Script Options
- Set Desired Script Options ( 4K/HDR/3D Posters/Banners )

  
  Save Configuration and you are good to go. 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
fi
#"
