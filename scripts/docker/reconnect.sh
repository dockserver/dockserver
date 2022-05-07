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
function reconnect() {
mapfile -t dockers < <(evaldocker ps -aq --format='{{.Names}}' | sort -u)
for rec in ${dockers[@]}; do
    $(which docker) stop $rec &>/dev/null
    if [[ $rec == "mount" ]]; then
       for fod in /mnt/* ;do
          basename "$fod" >/dev/null
          FOLDER="$(basename -- $fod)"
          IFS=- read -r <<< "$ACT"
          if ! ls -1p "$fod/" >/dev/null ; then
             $(which fusermount) -uzq /mnt/$FOLDER
          fi
       done
    fi
    $(which docker) network disconnect proxy $rec &>/dev/null
    $(which docker) network connect proxy $rec &>/dev/null
    $(which docker) start $rec &>/dev/null
done
}

reconnect
