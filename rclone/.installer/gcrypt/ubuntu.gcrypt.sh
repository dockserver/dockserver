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
  if [[ $EUID -ne 0 ]]; then
    exit 0
  fi
  while true; do
    basefolder="/opt/appdata"
    if [[ ! -x $(command -v docker) ]]; then exit; fi
    if [[ ! -x $(command -v docker-compose) ]]; then exit; fi
    if [[ -f "$basefolder/system/rclone/.env" ]]; then $(command -v rm) -rf $basefolder/system/rclone/.env; fi
    $(command -v docker) system prune -af 1>/dev/null 2>&1
    pulls="ghcr.io/dockserver/docker-rclone:latest"
    for pull in ${pulls}; do
      $(command -v docker) pull $pull --quiet
    done
    clear && headinterface
    ##clear && checkfields && interface
  done
}
headinterface() {
  echo "gdrive used "
  sleep 5 && exit
}
##
appstartup
#"
