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
ds=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -x 'traefik')
if [[ ${ds} == "" ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You deploy Traefik before you can deploy any Apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
sleep 30 && exit
fi

if [[ $EUID -ne 0 ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
exit 0
fi

while true;do
  if [[ ! -x $(command -v docker) ]];then exit;fi
  if [[ ! -x $(command -v docker-compose) ]];then exit;fi
  killport && headinterface
done
}
killport() {
port=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -x 'portainer')
if [[ ${port} != "" ]]; then
   $(command -v docker) stop ${port}
   $(command -v docker) rm ${port}
   $(command -v rm) -rf /opt/appdata/${port}
fi
}
headinterface() {
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  DockServer Applications Section Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Install  Apps
    [ 2 ] Remove   Apps
    [ 3 ] Backup   Apps
    [ 4 ] Restore  Apps

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && interface ;;
    2) clear && removeapp ;;
    3) clear && backupstorage ;;
    4) clear && restorestorage ;;
    Z|z|exit|EXIT|Exit|close) exit ;;
    *) appstartup ;;
  esac
}
interface() {
buildshow=$(ls -1p /opt/dockserver/apps/ | grep '/$' | $(command -v sed) 's/\/$//')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Applications Category Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$buildshow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↘️  Type Section Name and Press [ENTER]: " section </dev/tty
  if [[ $section == "exit" || $section == "Exit" || $section == "EXIT" || $section  == "z" || $section == "Z" ]];then clear && headinterface;fi
  if [[ $section == "" ]];then clear && interface;fi
     checksection=$(ls -1p /opt/dockserver/apps/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $section)
  if [[ $checksection == "" ]];then clear && interface;fi
  if [[ $checksection == $section ]];then clear && install;fi
}
install() {
restorebackup=null
section=${section}
buildshow=$(ls -1p /opt/dockserver/apps/${section}/ | sed -e 's/.yml//g' )
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Applications to install under ${section} category
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$buildshow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type App-Name to install and Press [ENTER]: " typed </dev/tty
  if [[ $typed == "exit" || $typed == "Exit" || $typed == "EXIT" || $typed  == "z" || $typed == "Z" ]];then clear && interface;fi
  if [[ $typed == "" ]];then clear && install;fi
     buildapp=$(ls -1p /opt/dockserver/apps/${section}/ | $(command -v sed) -e 's/.yml//g' | grep -x $typed)
  if [[ $buildapp == "" ]];then clear && install;fi
  if [[ $buildapp == $typed ]];then clear && runinstall;fi
}
### backup docker ###
backupstorage() {
storagefolder=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//')
if [[ $storagefolder == "" ]];then 
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 You need to set a backup folder
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  if [[ $storage == "exit" || $storage == "Exit" || $storage == "EXIT" || $storage  == "z" || $storage == "Z" ]];then clear && interface;fi
  if [[ $storage == "" ]];then clear && backupstorage;fi
  if [[ $storage != "" ]];then $(command -v mkdir) -p /mnt/unionfs/appbackups/${storage};fi
     teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage)
  if [[ $teststorage == $storage ]];then backupdocker;fi
else
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$storagefolder

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  if [[ $storage == "exit" || $storage == "Exit" || $storage == "EXIT" || $storage  == "z" || $storage == "Z" ]];then clear && interface;fi
  if [[ $storage == "" ]];then clear && backupstorage;fi
     teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage)
  if [[ $teststorage == $storage ]];then backupdocker;fi
  if [[ $storage != "" ]];then 
     $(command -v mkdir) -p /mnt/unionfs/appbackups/${storage}
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  New Backup folder set to $storage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
sleep 3
backupdocker
  fi
fi
}
backupdocker() {
storage=${storage}
rundockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -v 'trae' | grep -v 'auth' | grep -v 'cf-companion' | grep -v 'mongo' | grep -v 'dockupdater' | grep -v 'sudobox')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup running Dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$rundockers

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ all = Backup all running Container ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type App-Name to Backup and Press [ENTER]: " typed </dev/tty
  if [[ $typed == "exit" || $typed == "Exit" || $typed == "EXIT" || $typed  == "z" || $typed == "Z" ]];then clear && interface;fi
  if [[ $typed == "" ]];then clear && backupdocker;fi
  if [[ $typed == "help" || $typed == "HELP" ]];then clear && helplayout;fi
  if [[ $typed == "all" || $typed == "All" || $typed == "ALL" ]];then clear && backupall;fi
     builddockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -x ${typed})
  if [[ $builddockers == "" ]];then clear && backupdocker;fi
  if [[ $builddockers == $typed ]];then clear && runbackup;fi
}
backupall() {
OPTIONSTAR="--warning=no-file-changed \
  --ignore-failed-read \
  --absolute-names \
  --exclude-from=/opt/dockserver/apps/.backup/backup_excludes \
  --warning=no-file-removed \
  --use-compress-program=pigz"
STORAGE=${storage}
FOLDER="/opt/appdata"
DESTINATION="/mnt/downloads/appbackups"
dockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -v 'trae' | grep -v 'auth' | grep -v 'cf-companion' | grep -v 'mongo' | grep -v 'dockupdater' | grep -v 'sudobox')
for i in ${dockers};do
   ARCHIVE=$i
   ARCHIVETAR=${ARCHIVE}.tar.gz
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup is running for $i
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   if [[ ! -d ${DESTINATION} ]];then $(command -v mkdir) -p ${DESTINATION};fi
   if [[ ! -d ${DESTINATION}/${STORAGE} ]];then $(command -v mkdir) -p ${DESTINATION}/${STORAGE};fi
   forcepush="tar pigz pv"
   for fc in ${forcepush};do
       $(command -v apt) install $fc -yqq 1>/dev/null 2>&1 && sleep 1
   done
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}";do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]];then
      $(command -v docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Please Wait it cant take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
      $(command -v docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
   else
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   fi
   $(command -v chown) -hR 1000:1000 ${DESTINATION}/${STORAGE}/${ARCHIVETAR}
done
clear && backupdocker
}
runbackup() {
OPTIONSTAR="--warning=no-file-changed \
  --ignore-failed-read \
  --absolute-names \
  --exclude-from=/opt/dockserver/apps/.backup/backup_excludes \
  --warning=no-file-removed \
  --use-compress-program=pigz"
typed=${typed}
STORAGE=${storage}
FOLDER="/opt/appdata"
DESTINATION="/mnt/downloads/appbackups"
if [[ -d ${FOLDER}/${typed} ]];then
   ARCHIVE=${typed}
   ARCHIVETAR=${ARCHIVE}.tar.gz
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup is running for ${typed}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   if [[ ! -d ${DESTINATION} ]];then $(command -v mkdir) -p ${DESTINATION};fi
   if [[ ! -d ${DESTINATION}/${STORAGE} ]];then $(command -v mkdir) -p ${DESTINATION}/${STORAGE};fi
   forcepush="tar pigz pv"
   for fc in ${forcepush};do
       $(command -v apt) install $fc -yqq 1>/dev/null 2>&1 && sleep 1
   done
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}";do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]];then
      $(command -v docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Please Wait it cant take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
      $(command -v docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
   else
      $(command -v tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   fi
      $(command -v chown) -hR 1000:1000 ${DESTINATION}/${STORAGE}/${ARCHIVETAR}
   clear && backupdocker
else
   clear && backupdocker
fi
}
restorestorage() {
storage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -v 'sudobox')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$storage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  if [[ $storage == "exit" || $storage == "Exit" || $storage == "EXIT" || $storage  == "z" || $storage == "Z" ]];then clear && interface;fi
  if [[ $storage == "" ]];then clear && backupstorage;fi
     teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage)
  if [[ $teststorage == $storage ]];then clear && restoredocker;fi
}
restoredocker() {
storage=${storage}
runrestore=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -v 'trae' | grep -v 'auth' | grep -v 'sudobox')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore Dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$runrestore

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type App-Name to Restore and Press [ENTER]: " typed </dev/tty
  if [[ $typed == "exit" || $typed == "Exit" || $typed == "EXIT" || $typed  == "z" || $typed == "Z" ]];then clear && interface;fi
  if [[ $typed == "" ]];then clear && restoredocker;fi
  if [[ $typed == "help" || $typed == "HELP" ]];then clear && helplayout;fi
  if [[ $typed == "all" || $typed == "All" || $typed == "ALL" ]];then clear && restoreall;fi
     builddockers=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -x $typed)
  if [[ $builddockers == "" ]];then clear && restoredocker;fi
  if [[ $builddockers == $typed ]];then clear && runrestore;fi
}
restoreall() {
STORAGE=${storage}
FOLDER="/opt/appdata"
DESTINATION="/mnt/unionfs/appbackups"
apps=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -v 'trae' | grep -v 'auth' | grep -v 'sudobox')
forcepush="tar pigz pv"
for fc in ${forcepush};do
     $(command -v apt) install $fc -yqq 1>/dev/null 2>&1 && sleep 1
done
for app in ${apps};do
   basefolder="/opt/appdata"
   if [[ ! -d $basefolder/$app ]];then
   ARCHIVE=$app
   ARCHIVETAR=${ARCHIVE}.tar.gz
      echo "Create folder for $i is running"  
      folder=$basefolder/$app
      for appset in ${folder};do
          $(command -v mkdir) -p $appset
          $(command -v find) $appset -exec $(command -v chmod) a=rx,u+w {} \;
          $(command -v find) $appset -exec $(command -v chown) -hR 1000:1000 {} \;
      done
   fi
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore is running for $i
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   $(command -v unpigz) -dcqp 8 ${DESTINATION}/${STORAGE}/${ARCHIVETAR} | $(command -v pv) -pterb | $(command -v tar) pxf - -C ${FOLDER}/${ARCHIVE} --strip-components=1
done
clear && headinterface
}
runrestore() {
typed=${typed}
STORAGE=${storage}
FOLDER="/opt/appdata"
ARCHIVE=${typed}
ARCHIVETAR=${ARCHIVE}.tar.gz
restorebackup=restoredocker
DESTINATION="/mnt/unionfs/appbackups"
basefolder="/opt/appdata"
compose="compose/docker-compose.yml"
forcepush="tar pigz pv"
for fc in ${forcepush};do
    $(command -v apt) install $fc -yqq 1>/dev/null 2>&1 && sleep 1
done
if [[ ! -d $basefolder/${typed} ]];then
   folder=$basefolder/${typed}
   for i in ${folder};do
       $(command -v mkdir) -p $i
       $(command -v find) $i -exec $(command -v chmod) a=rx,u+w {} \;
       $(command -v find) $i -exec $(command -v chown) -hR 1000:1000 {} \;
   done
fi
builddockers=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -x $typed)
if [[ $builddockers == $typed ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore is running for ${typed}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   $(command -v unpigz) -dcqp 8 ${DESTINATION}/${STORAGE}/${ARCHIVETAR} | $(command -v pv) -pterb | $(command -v tar) pxf - -C ${FOLDER}/${ARCHIVE} --strip-components=1
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}";do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   section=${section}
   typed=${typed}
   restorebackup=${restorebackup}
   runinstall && clear
else
   clear && restoredocker
fi
}
runinstall() {
  restorebackup=${restorebackup:-null}
  section=${section}
  typed=${typed}
  updatecompose
  compose="compose/docker-compose.yml"
  composeoverwrite="compose/docker-compose.override.yml"
  storage="/mnt/downloads"
  appfolder="/opt/dockserver/apps"
  basefolder="/opt/appdata"
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Please Wait, We are installing ${typed} for you
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  if [[ ! -d $basefolder/compose/ ]];then $(command -v mkdir) -p $basefolder/compose/;fi
  if [[ ! -x $(command -v rsync) ]];then $(command -v apt) install rsync -yqq >/dev/null 2>&1;fi
  if [[ -f $basefolder/$compose ]];then $(command -v rm) -rf $basefolder/$compose;fi
  if [[ -f $basefolder/$composeoverwrite ]];then $(command -v rm) -rf $basefolder/$composeoverwrite;fi
  if [[ ! -f $basefolder/$compose ]];then $(command -v rsync) $appfolder/${section}/${typed}.yml $basefolder/$compose -aqhv;fi
  if [[ ! -x $(command -v lshw) ]];then $(command -v apt) install lshw -yqq >/dev/null 2>&1;fi
  if [[ ${section} == "mediaserver" || ${section} == "encoder" ]];then
     if [[ -x "/dev/dri" ]]; then
        gpu="Intel NVIDIA"
        for i in ${gpu};do
            lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E $i | while read -r -a $i; do
              $(command -v rsync) $appfolder/${section}/.gpu/$i.yml $basefolder/$composeoverwrite -aqhv
            done
        done
        if [[ -f $basefolder/$composeoverwrite ]];then
           if [[ $(uname) == "Darwin" ]];then
              $(command -v sed) -i '' "s/<APP>/${typed}/g" $basefolder/$composeoverwrite
           else
              $(command -v sed) -i "s/<APP>/${typed}/g" $basefolder/$composeoverwrite
           fi
        fi
     fi
  fi
  if [[ -f $appfolder/${section}/.overwrite/${typed}.overwrite.yml ]];then $(command -v rsync) $appfolder/${section}/.overwrite/${typed}.overwrite.yml $basefolder/$composeoverwrite -aqhv;fi
  if [[ ! -d $basefolder/${typed} ]];then
     folder=$basefolder/${typed}
     for fol in ${folder};do
         $(command -v mkdir) -p $fol
         $(command -v find) $fol -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $fol -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  container=$($(command -v docker) ps -aq --format '{{.Names}}' | grep -x ${typed})
  if [[ $container == ${typed} ]];then
     docker="stop rm"
     for con in ${docker};do
         $(command -v docker) $con ${typed} 1>/dev/null 2>&1
     done
     $(command -v docker) image prune -af 1>/dev/null 2>&1
  else
     $(command -v docker) image prune -af 1>/dev/null 2>&1
  fi
  if [[ ${section} == "addons" && ${typed} == "vnstat" ]];then vnstatcheck;fi
  if [[ ${section} == "mediaserver" && ${typed} == "plex" ]];then plexclaim && plex443;fi
  if [[ ${section} == "downloadclients" && ${typed} == "jdownloader2" ]];then
     folder=$storage/${typed}
     for jdl in ${folder};do
         $(command -v mkdir) -p $jdl
         $(command -v find) $jdl -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $jdl -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${section} == "downloadclients" && ${typed} == "rutorrent" ]];then
     folder=$storage/torrent
     for rto in ${folder};do
         $(command -v mkdir) -p $rto/{temp,complete}/{movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux}
         $(command -v find) $rto -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $rto -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${section} == "mediamanager" && ${typed} == "lidarr" ]];then
     folder=$storage/amd
     for lid in ${folder};do
         $(command -v mkdir) -p $lid
         $(command -v find) $lid -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $lid -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${section} == "mediamanager" && ${typed} == "readarr" ]];then
     folder=$storage/books
     for rea in ${folder};do
         $(command -v mkdir) -p $rea
         $(command -v find) $rea -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $rea -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${section} == "system" && ${typed} == "mount" ]];then
     $(command -v docker) stop mount &>/dev/null && $(command -v docker) rm mount &>/dev/null
     $(command -v fusermount) -uzq /mnt/{unionfs,remotes,rclone_cache} &>/dev/null
  fi
  if [[ ${section} == "downloadclients" && ${typed} == "youtubedl-material" ]];then
     folder="appdata audio video subscriptions"
     for ytf in ${folder};do
         $(command -v mkdir) -p $basefolder/${typed}/$ytf
         $(command -v find) $basefolder/${typed}/$ytf -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $basefolder/${typed}/$ytf -exec $(command -v chown) -hR 1000:1000 {} \;
     done
     folder=$storage/youtubedl
     for ytdl in ${folder};do
         $(command -v mkdir) -p $ytdl
         $(command -v find) $ytdl -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $ytdl -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "handbrake" ]];then
     folder=$storage/${typed}
     for hbrake in ${folder};do
         $(command -v mkdir) -p $hbrake/{watch,storage,output}
         $(command -v find) $hbrake -exec $(command -v chmod) a=rx,u+w {} \;
         $(command -v find) $hbrake -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "invitarr" ]];then
      $(command -v nano) $basefolder/$compose      
      $(command -v rsync) $appfolder/.subactions/${typed}.js $basefolder/${typed}/config.ini -aqhv
      $(command -v nano) $basefolder/${typed}/config.ini
  fi
  if [[ -f "${appfolder}/.subactions/${typed}.sh" ]]; then
     $(command -v bash) "${appfolder}/.subactions/${typed}.sh"
  fi
  if [[ ${typed} == "petio" ]];then $(command -v mkdir) -p $basefolder/${typed}/{db,config,logs} && $(command -v chown) -hR 1000:1000 $basefolder/${typed}/{db,config,logs} 1>/dev/null 2>&1;fi
  if [[ ${typed} == "tdarr" ]];then $(command -v mkdir) -p $basefolder/${typed}/{server,configs,logs,encoders} && $(command -v chown) -hR 1000:1000 $basefolder/${typed}/{server,configs,logs} 1>/dev/null 2>&1;fi
  if [[ -f $basefolder/$compose ]];then
     $(command -v cd) $basefolder/compose/
     $(command -v docker-compose) config 1>/dev/null 2>&1
     errorcode=$?
     if [[ $errorcode -ne 0 ]];then
  printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR
    Compose check of ${typed} has failed
    Return code is ${errorcode}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Confirm Info | PRESS [ENTER]" confirm </dev/tty
  clear && interface
     else
       composer=$(command -v docker-compose)
       for i in ${composer};do
          $i up -d --force-recreate 1>/dev/null 2>&1
       done
     fi
  fi
  if [[ ${section} == "mediaserver" || ${section} == "request" ]];then subtasks;fi
  if [[ ${typed} == "xteve" || ${typed} == "heimdall" || ${typed} == "librespeed" || ${typed} == "tautulli" || ${typed} == "nextcloud" ]];then subtasks;fi
  if [[ ${section} == "downloadclients" ]];then subtasks;fi
  if [[ ${typed} == "overseerr" ]];then overserrf2ban;fi
     setpermission
     $($(command -v docker) ps -aq --format '{{.Names}}{{.State}}' | grep -qE ${typed}running 1>/dev/null 2>&1)
     errorcode=$?
  if [[ $errorcode -eq 0 ]];then
     TRAEFIK=$(cat $basefolder/$compose | grep "traefik.enable" | wc -l)
  if [[ ${TRAEFIK} == "0" ]];then
  printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} has successfully deployed and is now working     
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
else
  source $basefolder/compose/.env
  printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} has successfully deployed = > https://${typed}.${DOMAIN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  sleep 10
  clear
  fi
  fi
  if [[ -f $basefolder/$compose ]];then $(command -v rm) -rf $basefolder/$compose;fi
  if [[ -f $basefolder/$composeoverwrite ]];then $(command -v rm) -rf $basefolder/$composeoverwrite;fi
  if [[ ${restorebackup} == "restoredocker" ]];then clear && restorestorage;fi
  clear && install
}
setpermission() {
approot=$($(command -v ls) -l $basefolder/${typed} | awk '{if($3=="root") print $0}' | wc -l)
if [[ $approot -gt 0 ]];then
IFS=$'\n'
mapfile -t setownapp < <(eval $(command -v ls) -l $basefolder/${typed}/ | awk '{if($3=="root") print $0}' | awk '{print $9}')
  for appset in ${setownapp[@]};do
      if [[ $(whoami) == "root" ]];then $(command -v chown) -hR 1000:1000 $basefolder/${typed}/$appset;fi
      if [[ $(whoami) != "root" ]];then $(command -v chown) -hR $(whoami):$(whoami) $basefolder/${typed}/$appset;fi
  done
fi
dlroot=$($(command -v ls) -l $storage/ | awk '{if($3=="root") print $0}' | wc -l)
if [[ $dlroot -gt 0 ]];then
IFS=$'\n'
mapfile -t setowndl < <(eval $(command -v ls) -l $storage/ | awk '{if($3=="root") print $0}' | awk '{print $9}')
  for dlset in ${setowndl[@]};do
      if [[ $(whoami) == "root" ]];then $(command -v chown) -hR 1000:1000 $storage/$dlset;fi
      if [[ $(whoami) != "root" ]];then $(command -v chown) -hR $(whoami):$(whoami) $storage/$dlset;fi
  done
fi
}
overserrf2ban() {
OV2BAN="/etc/fail2ban/filter.d/overseerr.local"
if [[ ! -f $OV2BAN ]];then
   cat > $OV2BAN << EOF; $(echo)
## overseerr fail2ban filter ##
[Definition]
failregex = .*\[info\]\[Auth\]\: Failed sign-in attempt.*"ip":"<HOST>"
EOF
fi
f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
if [[ $f2ban != "false" ]];then $(command -v systemctl) reload-or-restart fail2ban.service 1>/dev/null 2>&1;fi
}
vnstatcheck() {
if [[ ! -x $(command -v vnstat) ]];then $(command -v apt) install vnstat -yqq;fi
}
lubox() {
basefolder="/opt/appdata"
kbox=$($(command -v docker) ps --format '{{.Image}}' | grep -E 'box' | grep -v 'cloudb0x')
lbox=$($(command -v find) $basefolder/ -maxdepth 2 -name '*box' -type d)
if [[ $kbox != "" || $lbox != "" ]];then
   box=$($(command -v docker) pa -aq --format {{.Names}} | grep -E 'box')
   for nb in ${box};do
       del="stop rm"
       for del in ${delb};do
          $(command -v docker) $del $nb 1>/dev/null 2>&1
          $(command -v docker) system prune -af 1>/dev/null 2>&1
          $(command -v rm) -rf $basefolder/$nb 1>/dev/null 2>&1
       done
   done
fi
}
plexclaim() {
compose="compose/docker-compose.yml"
basefolder="/opt/appdata"
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  PLEX CLAIM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Please claim your Plex server
    https://www.plex.tv/claim/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Enter your PLEX CLAIM CODE : " PLEXCLAIM </dev/tty
  if [[ $PLEXCLAIM != "" ]];then
     if [[ $(uname) == "Darwin" ]];then
        $(command -v sed) -i '' "s/PLEX_CLAIM_ID/$PLEXCLAIM/g" $basefolder/$compose
     else
        $(command -v sed) -i "s/PLEX_CLAIM_ID/$PLEXCLAIM/g" $basefolder/$compose
     fi
  else
     echo "Plex Claim cannot be empty"
     plexclaim
  fi
}
plex443() {
basefolder="/opt/appdata"
source $basefolder/compose/.env
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  PLEX 443 Options
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    You need to add a Cloudflare Page Rule
    https://dash.cloudflare.com/
    > Domain
      > Rules
        > add new rule
          > Domain : plex.${DOMAIN}/*
          > cache-level: bypass
        > save
    __________________

    > in plex settings
      > settings
        > remote access
          > remote access = enabled
          > manual port 32400
          > save
        > network
          > Strict TLS configuration [ X ]
          > allowed networks = 172.18.0.0
          > save 
      > have fun !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "Confirm Info | PRESS [ENTER]" confirm </dev/tty

}
subtasks() {
typed=${typed}
section=${section}
basefolder="/opt/appdata"
appfolder="/opt/dockserver/apps"
source $basefolder/compose/.env
authcheck=$($(command -v docker) ps -aq --format '{{.Names}}' | grep -x 'authelia' 1>/dev/null 2>&1 && echo true || echo false)
conf=$basefolder/authelia/configuration.yml
confnew=$basefolder/authelia/.new-configuration.yml.new
confbackup=$basefolder/authelia/.backup-configuration.yml.backup
authadd=$(cat $conf | grep -E ${typed})
  if [[ ! -x $(command -v ansible) || ! -x $(command -v ansible-playbook) ]];then $(command -v apt) install ansible -yqq;fi
  if [[ -f $appfolder/.subactions/${typed}.yml ]];then $(command -v ansible-playbook) $appfolder/.subactions/${typed}.yml;fi
     $(grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | head -n1 |grep -qE 'i7|i9' 1>/dev/null 2>&1)
     setcode=$?
     if [[ $setcode -eq 0 ]];then
        if [[ -f $appfolder/.subactions/${typed}.sh ]];then $(command -v bash) $appfolder/.subactions/${typed}.sh;fi
     fi
  if [[ $authadd == "" ]];then
     if [[ ${section} == "mediaserver" || ${section} == "request" ]];then
     { head -n 55 $conf;
     echo "\
    - domain: ${typed}.${DOMAIN}
      policy: bypass"; tail -n +56 $conf; } > $confnew
        if [[ -f $conf ]];then $(command -v rsync) $conf $confbackup -aqhv;fi
        if [[ -f $conf ]];then $(command -v rsync) $confnew $conf -aqhv;fi
        if [[ $authcheck == "true" ]];then $(command -v docker) restart authelia 1>/dev/null 2>&1;fi
        if [[ -f $conf ]];then $(command -v rm) -rf $confnew;fi
     fi
     if [[ ${typed} == "xteve" || ${typed} == "heimdall" || ${typed} == "librespeed" || ${typed} == "tautulli" || ${typed} == "nextcloud" ]];then
     { head -n 55 $conf;
     echo "\
    - domain: ${typed}.${DOMAIN}
      policy: bypass"; tail -n +56 $conf; } > $confnew
        if [[ -f $conf ]];then $(command -v rsync) $conf $confbackup -aqhv;fi
        if [[ -f $conf ]];then $(command -v rsync) $confnew $conf -aqhv;fi
        if [[ $authcheck == "true" ]];then $(command -v docker) restart authelia 1>/dev/null 2>&1;fi
        if [[ -f $conf ]];then $(command -v rm) -rf $confnew;fi
     fi
  fi
  if [[ ${section} == "mediaserver" || ${section} == "request" || ${section} == "downloadclients" ]];then $(command -v docker) restart ${typed} 1>/dev/null 2>&1;fi
  if [[ ${section} == "request" ]];then $(command -v chown) -R 1000:1000 $basefolder/${typed} 1>/dev/null 2>&1;fi
}
removeapp() {
list=$($(command -v docker) ps -aq --format '{{.Names}}' | grep -vE 'auth|trae|cf-companion')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   App Removal Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$list

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "↪️ Type App-Name to remove and Press [ENTER]: " typed </dev/tty
  if [[ $typed == "exit" || $typed == "Exit" || $typed == "EXIT" || $typed  == "z" || $typed == "Z" ]];then interface;fi
  if [[ $typed == "" ]];then clear && removeapp;fi
     checktyped=$($(command -v docker) ps -aq --format={{.Names}} | grep -x $typed)
  if [[ $checktyped == $typed ]];then clear && deleteapp;fi
}
deleteapp() {
  typed=${typed}
  basefolder="/opt/appdata"
  storage="/mnt/downloads"
  source $basefolder/compose/.env
  conf=$basefolder/authelia/configuration.yml
  checktyped=$($(command -v docker) ps -aq --format={{.Names}} | grep -x $typed)
  auth=$(cat -An $conf | grep -x ${typed}.${DOMAIN} | awk '{print $1}')
  if [[ $checktyped == $typed ]];then
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} removal started    
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
     app=${typed}
     for i in ${app};do
         $(command -v docker) stop $i 1>/dev/null 2>&1
         $(command -v docker) rm $i 1>/dev/null 2>&1
         $(command -v docker) image prune -af 1>/dev/null 2>&1
     done
     if [[ -d $basefolder/${typed} ]];then 
        folder=$basefolder/${typed}
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   App ${typed} folder removal started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
        for i in ${folder};do
            $(command -v rm) -rf $i 1>/dev/null 2>&1
        done
     fi
     if [[ -d $storage/${typed} ]];then 
        folder=$storage/${typed}
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Storage ${typed} folder removal started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
        for i in ${folder};do
            $(command -v rm) -rf $i 1>/dev/null 2>&1
        done
     fi
     if [[ $auth == ${typed} ]];then
        if [[ ! -x $(command -v bc) ]];then $(command -v apt) install bc -yqq 1>/dev/null 2>&1;fi
           source $basefolder/compose/.env
           authrmapp=$(cat -An $conf | grep -x ${typed}.${DOMAIN})
           authrmapp2=$(echo "$(${authrmapp} + 1)" | bc)
        if [[ $authrmapp != "" ]];then sed -i '${authrmapp};${authrmapp2}d' $conf;fi
           $($(command -v docker) ps -aq --format '{{.Names}}' | grep -x authelia 1>/dev/null 2>&1)
           newcode=$?
        if [[ $newcode -eq 0 ]];then $(command -v docker) restart authelia;fi
     fi
     source $basefolder/compose/.env 
     if [ ${DOMAIN1_ZONE_ID} != "" ] && [ ${DOMAIN} != "" ] && [ ${CLOUDFLARE_EMAIL} != "" ] ; then
        if [[ $(command -v curl) == "" ]] ; then $(command -v apt) install curl -yqq 1>/dev/null 2>&1; fi
        dnsrecordid=$(curl -sX GET "https://api.cloudflare.com/client/v4/zones/$DOMAIN1_ZONE_ID/dns_records?name=${typed}.${DOMAIN}" -H "X-Auth-Email: $CLOUDFLARE_EMAIL" -H "X-Auth-Key: $CLOUDFLARE_API_KEY" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
        if [[ $dnsrecordid != "" ]] ; then
           result=$(curl -sX DELETE "https://api.cloudflare.com/client/v4/zones/$DOMAIN1_ZONE_ID/dns_records/$dnsrecordid" -H "X-Auth-Email: $CLOUDFLARE_EMAIL" -H "X-Auth-Key: $CLOUDFLARE_API_KEY" -H "Content-Type: application/json")
           if [[ $result != "" ]]; then
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} CNAME record removed from Cloudflare 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"          
           fi
        fi
    fi
    printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} removal finished
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
    sleep 2 && removeapp
  else
     removeapp
  fi
}
updatecompose() {
if [[ ! -x $(command -v docker-compose) ]];then 
   if [[ -f /usr/bin/docker-compose ]];then rm -rf /usr/bin/docker-compose /usr/local/bin/docker-compose;fi
   curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/bin/docker-compose
   curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
   $(command -v chmod) +x /usr/local/bin/docker-compose
   $(command -v chmod) a=rx,u+w /usr/local/bin/docker-compose >/dev/null 2>&1 
   $(command -v chmod) a=rx,u+w /usr/bin/docker-compose >/dev/null 2>&1
fi
}
##########
lubox
appstartup

##E-o-F##
