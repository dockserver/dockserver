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

## sample crontab ##
## sudo crontab -e 
## ## Autobackup all Dockers 
## 5 3 * * * bash /opt/dockserver/scripts/backup/backupdate.sh >/dev/null 2>&1
## 03:05 each day to storage date 
## sample date 2021-07-22

STORAGE=$(date "+%Y-%m-%d")
HOSTNAME=$(hostname)

OPTIONSTAR="--warning=no-file-changed \
  --ignore-failed-read \
  --absolute-names \
  --exclude-from=/opt/dockserver/apps/.backup/backup_excludes \
  --warning=no-file-removed \
  --use-compress-program=pigz"

FOLDER="/opt/appdata"
DESTINATION="/mnt/downloads/appbackups"
dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -v 'trae' | grep -v 'auth' | grep -v 'cf-companion' | grep -v 'mongo' | grep -v 'dockupdater' | grep -v 'sbox')

for i in ${dockers};do
   ARCHIVE=$i
   ARCHIVETAR=${ARCHIVE}.tar.gz
   if [[ ! -d ${DESTINATION}/${HOSTNAME}/${STORAGE} ]];then $(command -v mkdir) -p ${DESTINATION}/${HOSTNAME}/${STORAGE};fi
   forcepush="tar pigz pv"
   for fc in ${forcepush};do
       $(command -v apt) install $fc --reinstall -yqq 1>/dev/null 2>&1 && sleep 1
   done
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}"; do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]];then
      $(command -v docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${HOSTNAME}/${STORAGE}/${ARCHIVETAR} ./
      $(command -v docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
   else
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${HOSTNAME}/${STORAGE}/${ARCHIVETAR} ./
   fi
   $(command -v chown) -hR 1000:1000 ${DESTINATION}/${HOSTNAME}/${STORAGE}/${ARCHIVETAR}
done

#EOF
