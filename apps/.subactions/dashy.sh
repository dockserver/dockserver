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

FOLDER="/opt/appdata"
CONF="${FOLDER}/dashy/conf.yml"
appfolder="/opt/dockserver/apps"
FILE=".subactions/dashy.j2"

appstartup() {
   if [[ -f $CONF ]]; then
      $(command -v chown) -cR 1000:1000 $FOLDER/dashy
   fi

   if [[ ! -f $CONF ]]; then
      $(command -v mkdir) -p $FOLDER/dashy
      $(command -v rsync) $appfolder/$FILE $CONF -aqhv
      $(command -v chown) -cR 1000:1000 $FOLDER/dashy
   fi
}

appstartup
#"
