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
  plex=$($(command -v docker) ps -a --format '{{.Names}}' | grep -x plex)
  if [[ $plex == "plex" ]];then
     X_PLEX_TOKEN=$(sudo cat "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
    curl --request PUT http://localhost:32400/library/optimize\?async=1\&X-Plex-Token=$X_PLEX_TOKEN
  else
     echo "No plex running"
  fi
break
done
#"