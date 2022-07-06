#!/usr/bin/with-contenv bash
# shellcheck shell=bash
##################################
# Copyright (c) 2021,  : MrDoob  #
# Docker owner         : doob187 #
# Docker Maintainer    : doob187 #
# Code owner           : doob187 #
#     All rights reserved        #
##################################
# THIS DOCKER IS UNDER LICENSE   #
# NO CUSTOMIZING IS ALLOWED      #
# NO REBRANDING IS ALLOWED       #
# NO CODE MIRRORING IS ALLOWED   #
##################################
# shellcheck disable=SC2086
# shellcheck disable=SC2006

$(which docker) system prune -af 1>/dev/null 2>&1
$(which docker) pull ghcr.io/dockserver/docker-backup:latest 1>/dev/null 2>&1

## check old uploader 
## stop docker-uploader
oldup=$($(which ls) -1p /opt/appdata/ | $(which grep) '/$' | $(which grep) -E 'uploader' | $(which sed) 's/\/$//')
if [[ ${oldup} != "" ]]; then
   $(which docker) stop ${oldup}
fi

pgblitz1=$(systemctl is-active pgblitz)
pgblitz2=$(systemctl is-active pgmove)
if [ "$pgblitz1" == "active" ] || [ "$pgblitz2" == "active" ];then
   echo  "***** BEWARE OWN RISK !!!! *****"
fi

## RUN LOOP FOR BACKUPS
$(which ls) -1p /opt/appdata/ \
    | $(which grep) '/$' | $(which grep) -v 'plexguide' | $(which grep) -v 'trae' | $(which grep) -v 'auth' | $(which grep) -v 'cf' \
    | $(which sed) 's/\/$//' | while read -ra TODO; do
    $(which docker) run --rm -v /opt/appdata:/backup/${TODO} -v /mnt:/mnt ghcr.io/dockserver/docker-backup:latest backup ${TODO} local
    $(which chown) -cR 1000:1000 /mnt/downloads/appbackups/local/${TODO}.tar.gz 1>/dev/null 2>&1
done

## bloody move folder hack
if [[ -d /mnt/move ]]; then
   $(which apt) install rsync -y
   $(which mkdir) -p /mnt/move/appbackups/local/
   shopt -s globstar
   mapfile -t files < <(eval find /mnt/downloads/appbackups/local/ -type f -name "*.tar.gz")
   for f in "${files[@]}"; do
       $(which mv) "${f}" /mnt/move/appbackups/local/
   done
   shopt -u globstar
fi

## start docker-uploader
oldup=$($(which ls) -1p /opt/appdata/ | $(which grep) '/$' | $(which grep) -E 'uploader' | $(which sed) 's/\/$//')
if [[ ${oldup} != "" ]]; then
   $(which docker) start ${oldup}
fi

$(which docker) system prune -af 1>/dev/null 2>&1
exit
#EOF
