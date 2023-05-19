#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.
#########################################################################
# Author:         l3uddz / m-rots && cloudbox                           #
# Docker:         https://github.com/Cloudbox/autoscan                  #
# URL:            https://github.com/Cloudbox/autoscan                  #
#         Part of the Cloudbox project: https://cloudbox.works          #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################

basefolder="/opt/appdata"
appfolder="/opt/dockserver/apps/"
typed=autoscan
composeoverwrite="compose/docker-compose.override.yml"
headrm() {
if [[ -f $basefolder/${typed}/autoscan.db ]];then $(command -v rm) -rf $basefolder/${typed}/autoscan.db;fi
}
anchor() {
if [[ ! -x $(command -v unzip) ]];then $(command -v apt) install unzip -yqq 1>/dev/null 2>&1;fi
if [[ ! -x $(command -v rclone) ]];then $(command -v curl) https://rclone.org/install.sh | sudo bash 1>/dev/null 2>&1;fi
if [[ ! -d "/mnt/unionfs/.anchors/" ]];then $(command -v mkdir) -p /mnt/unionfs/.anchors;fi
if [[ ! -f "/mnt/unionfs/.anchors/cloud.anchor" ]];then $(command -v touch) /mnt/unionfs/.anchors/cloud.anchor;fi
if [[ ! -f "/mnt/unionfs/.anchors/local.anchor" ]];then $(command -v touch) /mnt/unionfs/.anchors/local.anchor;fi
echo "\
" >> $basefolder/${typed}/config.yml && echo "\
anchors:
  - /mnt/unionfs/.anchors/cloud.anchor
  - /mnt/unionfs/.anchors/local.anchor" >> $basefolder/${typed}/config.yml
IFS=$'\n'
filter="$1"
mountd=$(docker ps -a --format={{.Names}} | grep -E "mount" && echo true || echo false)
if [[ $mountd == "false" ]];then
   if [[ -f "$basefolder/uploader/rclone.conf" ]];then config=$basefolder/uploader/rclone.conf;fi
   if [[ ! -f "$basefolder/uploader/rclone.conf" ]];then config=$basefolder/system/rclone/rclone.conf;fi
else
   if [[ -f "$basefolder/mount/rclone.conf" ]];then config=$basefolder/mount/rclone.conf;fi
   if [[ ! -f "$basefolder/mount/rclone.conf" ]];then config=$basefolder/system/rclone/rclone.conf;fi
fi
mapfile -t mounts < <(eval rclone listremotes --config=${config} | grep "$filter" | sed -e 's/://g' | sed '/union/d' | sed '/GDSA/d' | sort -r)
##### RUN MOUNT #####
for i in ${mounts[@]}; do
  $(command -v rclone) mkdir $i:/.anchors --config=${config}
  $(command -v rclone) touch $i:/.anchors/$i.anchor --config=${config}
echo "\
  - /mnt/unionfs/.anchors/$i.anchor" >> $basefolder/${typed}/config.yml
done
}
arrs() {
echo "\
" >> $basefolder/${typed}/config.yml && echo "\
triggers:
  manual:
    priority: 0" >> $basefolder/${typed}/config.yml
radarr=$(docker ps -a --format={{.Names}} | grep -E 'radarr' 1>/dev/null 2>&1 && echo true || echo false)
rrun=$(docker ps -a --format={{.Names}} | grep 'rada')
if [[ $radarr == "true" ]];then
echo "\
  radarr:" >> $basefolder/${typed}/config.yml
   for i in ${rrun};do
echo "\
    - name: $i
      priority: 2" >> $basefolder/${typed}/config.yml
   done
fi
sonarr=$(docker ps -a --format={{.Names}} | grep -E 'sonarr' 1>/dev/null 2>&1 && echo true || echo false)
srun=$(docker ps -a --format={{.Names}} | grep -E 'sona')
if [[ $sonarr == "true" ]];then
echo "\
  sonarr:" >> $basefolder/${typed}/config.yml
   for i in ${srun};do
echo "\
    - name: $i
      priority: 2" >> $basefolder/${typed}/config.yml
   done
fi
lidarr=$(docker ps -a --format={{.Names}} | grep -E 'lidarr' 1>/dev/null 2>&1 && echo true || echo false)
lrun=$(docker ps -a --format={{.Names}} | grep 'lida')
if [[ $lidarr == "true" ]];then
echo "\
  lidarr:" >> $basefolder/${typed}/config.yml
   for i in ${lrun};do
echo "\
    - name: $i
      priority: 2" >> $basefolder/${typed}/config.yml
   done
fi
}
targets() {
## inotify adding for the /mnt/unionfs
echo "\
  inotify:
    - priority: 1
      include:
        - ^/mnt/unionfs/
      exclude:
        - '\.(srt|pdf)$'
        - ^/mnt/unionfs/nzb/
        - ^/mnt/unionfs/torrent/
      paths:
      - path: /mnt/unionfs/

targets:" >> $basefolder/${typed}/config.yml
plex=$(docker ps -a --format={{.Names}} | grep -x 'plex' 1>/dev/null 2>&1 && echo true || echo false)
prun=$(docker ps -a --format={{.Names}} | grep -x 'plex')
if [[ -d "/opt/appdata/plex/" && $plex == "true" ]]; then
   token=$(cat "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
   if [[ $token == "" ]];then
      token=youneedtoreplacethemselfnow
   fi
   if [[ $plex == "true" ]];then
      for i in ${prun};do
   echo "\
  $i:
    - url: http://$i:32400
      token: $token" >> $basefolder/${typed}/config.yml
     done
   fi
fi
emby=$(docker ps -a --format={{.Names}} | grep -x 'emby' 1>/dev/null 2>&1 && echo true || echo false)
erun=$(docker ps -a --format={{.Names}} | grep -x 'emby')
token=youneedtoreplacethemselfnow
if [[ $emby == "true" ]];then
   for i in ${erun};do
echo "\
  $i:
    - url: http://$i:8096
      token: $token" >> $basefolder/${typed}/config.yml
   done
fi
jelly=$(docker ps -a --format={{.Names}} | grep -x 'jelly' 1>/dev/null 2>&1 && echo true || echo false)
jrun=$(docker ps -a --format={{.Names}} | grep -x 'jelly')
token=youneedtoreplacethemselfnow
if [[ $jelly == "true" ]];then
   for i in ${jrun};do
echo "\
  $i:
    - url: http://$i:8096
      token: $token" >> $basefolder/${typed}/config.yml
   done
fi
}
autoscantarget() {
echo "\
  autoscan:
    - url: http://autoscan:3030
      username: $USERAUTOSCAN
      password: $PASSWORD" >> $basefolder/${typed}/config.yml
}
addauthuser() {
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     🚀   autoscan Username
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   read -erp "Enter a username for autoscan?: " USERAUTOSCAN </dev/tty
if [[ $USERAUTOSCAN != "" ]]; then
   if [[ $(uname) == "Darwin" ]]; then
      sed -i '' "s/<USERNAME>/$USERAUTOSCAN/g" $basefolder/${typed}/config.yml
   else
      sed -i "s/<USERNAME>/$USERAUTOSCAN/g" $basefolder/${typed}/config.yml
   fi
else
  echo "Username for autoscan cannot be empty"
  addauthuser
fi
}
addauthpassword() {
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     🚀   autoscan Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   read -erp "Enter a password for $USERAUTOSCAN: " PASSWORD </dev/tty
if [[ $PASSWORD != "" ]]; then
   if [[ $(uname) == "Darwin" ]]; then
      sed -i '' "s/<PASSWORD>/$PASSWORD/g" $basefolder/${typed}/config.yml
   else
      sed -i "s/<PASSWORD>/$PASSWORD/g" $basefolder/${typed}/config.yml
   fi
else
  echo "Password for autoscan cannot be empty"
  addauthpassword
fi
}
showsettings() {
source /opt/appdata/compose/.env
arr=$($(command -v docker) ps -a --format={{.Names}} | grep -E 'arr' 1>/dev/null 2>&1 && echo true || echo false)
if [[ $arr == "true" ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     🚀   Arr settings ( SAMPLE )
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Username : $USERAUTOSCAN
 Password : $PASSWORD


 Heres how to connect with sonarr/radarr:

 Settings-> Connect-> Webhook

 Notification triggers:
           -->  Import
           -->  Upgrade
           -->  Rename
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  URL for radarr/sonarr

  http://autoscan:3030/triggers/radarr
  http://autoscan:3030/triggers/sonarr

  Method: POST

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
fi
plex=$(docker ps -a --format={{.Names}} | grep -E 'plex' 1>/dev/null 2>&1 && echo true || echo false)
if [[ $plex = "true" ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
In Plex Media Server
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  UNTICK:

- Scan my library automatically
- Run a partial scan when changes are detected

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
fi
jelly=$(docker ps -a --format={{.Names}} | grep -E 'jelly' 1>/dev/null 2>&1 && echo true || echo false)
if [[ $jelly = "true" ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
In Jellyfin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
While Jellyfin provides much better behaviour out of the box than Plex,
it still might be useful to use Autoscan for even better performance.

Token :

( must be added self )

We need a Jellyfin API Token to make requests on your behalf.
This article should help you out.

https://github.com/MediaBrowser/Emby/wiki/Api-Key-Authentication

It's a bit out of date, but I'm sure you will manage!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
fi
emby=$(docker ps -a --format={{.Names}} | grep -E 'emby' 1>/dev/null 2>&1 && echo true || echo false)
if [[ $emby = "true" ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
In Jellyfin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
While Jellyfin provides much better behaviour out of the box than Plex,
it still might be useful to use Autoscan for even better performance.

Token :

( must be added self )

We need a Jellyfin API Token to make requests on your behalf.
This article should help you out.

https://github.com/MediaBrowser/Emby/wiki/Api-Key-Authentication

It's a bit out of date, but I'm sure you will manage!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
fi
}
showending() {
source /opt/appdata/compose/.env
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     🚀   autoscan Details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 autoscandomain :

 Username : $USERAUTOSCAN
 Password : $PASSWORD

 local  : http://autoscan:3030/triggers/{name of app}
 remote : https://autoscan.${DOMAIN}/triggers/{name of app}
 manual : https://autoscan.${DOMAIN}/triggers/manual

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
}
runautoscan() {
   $(command -v rsync) $appfolder/.subactions/${typed}.config.yml $basefolder/${typed}/config.yml -aqhv
   $($(command -v docker) ps -a --format={{.Names}} | grep -E 'arr|ple|emb|jelly' 1>/dev/null 2>&1)
   errorcode=$?
if [[ $errorcode -eq 0 ]]; then
   headrm && anchor && arrs && targets && addauthuser && addauthpassword && autoscantarget && showsettings && showending
else
   app=${typed}
   for i in ${app}; do
       $(command -v docker) stop $i 1>/dev/null 2>&1
       $(command -v docker) rm $i 1>/dev/null 2>&1
       $(command -v docker) image prune -af 1>/dev/null 2>&1
   done
   if [[ -d $basefolder/${typed} ]];then
      folder=$basefolder/${typed}
      for i in ${folder}; do
          $(command -v rm) -rf $i 1>/dev/null 2>&1
      done
   fi
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                   ❌ ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         Sorry we cannot find any running
          Arrs , Plex , Emby or Jellyfin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
fi
}
runautoscan
#E-o-F#
