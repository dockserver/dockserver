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
while true; do
  if [[ ! -x $(command -v docker) ]];then exit;fi
  plex=$($(command -v docker) ps -aq --format '{{.Names}}' | grep -x plex)
  if [[ $plex == "plex" ]];then
     X_PLEX_TOKEN=$(sudo cat "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
     sectionid=$($(command -v docker) exec -it plex  /usr/lib/plexmediaserver/Plex\ Media\ Scanner --list | awk '{print $1}' | sed -e 's/://g')
     sectionname=$($(command -v docker) exec -it plex  /usr/lib/plexmediaserver/Plex\ Media\ Scanner --list | awk '{print $2}' | sed -e 's/://g')
     for sn in ${sectionname};do
         echo "Emptying trash for $sn"
         for id in ${sectionid};do
           curl -X PUT -H "X-Plex-Token: $X_PLEX_TOKEN" http://localhost:32400/library/sections/"$id"/emptyTrash
         done
     done
  else
     echo "No plex running"
  fi
break
done
#EOF