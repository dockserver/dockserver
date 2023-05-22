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

### START OF SETTINGS
## sample crontab
## sudo crontab -e

## ## Autobackup all Dockers
## 5 3 * * * bash /opt/dockserver/scripts/backup/backupdate.sh >/dev/null 2>&1

##### INFORMATIONS
## 03:05 each day to storage date
## BASIC setting is STORAGE=local
## sample date 2021-07-22
## DATE BASED setting is STORAGE=$(date "+%Y-%m-%d")
## STORAGE=local
## STORAGE=$(date "+%Y-%m-%d")

## Set your Discord Webhook URL here. Leave as "" if not used.
WEBHOOK_URL=""

## USER SETTINGS
STORAGE=local
### END OF SETTINGS

OPTIONSTAR="--warning=no-file-changed \
  --ignore-failed-read \
  --absolute-names \
  --exclude-from=/opt/dockserver/apps/.backup/backup_excludes \
  --warning=no-file-removed \
  --use-compress-program=pigz"

FOLDER="/opt/appdata"
DESTINATION="/mnt/downloads/appbackups"
dockers=$(docker ps -a --format '{{.Names}}' | sed '/^$/d' | grep -v 'trae' | grep -v 'auth' | grep -v 'cf-companion' | grep -v 'mongo' | grep -v 'dockupdater' | grep -v 'sbox')

for i in ${dockers}; do
   ARCHIVE=$i
   ARCHIVETAR=${ARCHIVE}.tar.gz
   if [[ ! -d ${DESTINATION}/${STORAGE} ]]; then $(command -v mkdir) -p ${DESTINATION}/${STORAGE}; fi
   forcepush="tar pigz pv"
   for fc in ${forcepush}; do
      $(command -v apt) install $fc --reinstall -yqq 1>/dev/null 2>&1 && sleep 1
   done
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}"; do
      section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]]; then
      $(command -v docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
      $(command -v docker) start ${typed} 1>/dev/null 2>&1 && echo "We started now $typed"
   else
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   fi
   $(command -v chown) -hR 1000:1000 ${DESTINATION}/${STORAGE}/${ARCHIVETAR}
   
   if [[ -n $WEBHOOK_URL ]]; then
       # Sending notification to Discord
       TIMESTAMP=$(date '+%H:%M:%S')
       curl -H "Content-Type: application/json" \
           -X POST \
           -d "{\"content\": \"Backup of $ARCHIVE in folder $STORAGE completed at $TIMESTAMP!\"}" \
           $WEBHOOK_URL
   fi
done
