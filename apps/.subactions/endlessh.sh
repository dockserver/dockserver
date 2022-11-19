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
# shellcheck disable=SC2003
# shellcheck disable=SC2006
# shellcheck disable=SC2207
# shellcheck disable=SC2012
# shellcheck disable=SC2086
# shellcheck disable=SC2196
# shellcheck disable=SC2046
#FUNCTIONS
random() {
  local min=$1
  local max=$2
  local RAND=`od -t uI -N 4 /dev/urandom | awk '{print $2}'`
  RAND=$((RAND%((($max-$min)+1))+$min))
  echo $RAND
}
defaultport() {
sshport=22
nowport=$(grep -P '^[#\s]*Port ' /etc/ssh/sshd_config | sed 's/[^0-9]*//g')
sed -i "/^\(\s\|#\)*Port $nowport/ c\Port $sshport" /etc/ssh/sshd_config
$(command -v systemctl) restart ssh && clear && ending
}
randomport() {
sshport=$(random 1500 3333)
sed -i "/^\(\s\|#\)*Port / c\Port $sshport" /etc/ssh/sshd_config
$(command -v systemctl) restart ssh && clear && ending
}
customeport() {
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Custome SSH Port
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Be careful !! if you lose the SSH Port
    you dont have any access to ssh
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
read -erp "↪️ Type SSH Port [ENTER]: " newport </dev/tty
if [[ ${newport} != "" ]];then
   if [[ ${newport} -le "65500" && ${newport} -gt "22" ]];then
      sshport=$newport
      sed -i "/^\(\s\|#\)*Port / c\Port $newport" /etc/ssh/sshd_config
   else
      clear && echo " Typed port is greater as 65000 or less then 22" && sleep 10 && customeport
   fi
else
   clear && echo " You need to type a new ssh port" && sleep 10 && customeport
fi
$(command -v systemctl) restart ssh && clear && ending
}
portchange() {
Portcheck=$(cat /etc/ssh/sshd_config | grep -qE '#Port' && echo true || echo false)
if [[ $Portcheck == "true" ]];then sed -i "s/#Port/Port/g" /etc/ssh/sshd_config;fi
nowport=$(grep -P '^[#\s]*Port ' /etc/ssh/sshd_config | sed 's/[^0-9]*//g')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Change SSH PORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    Active SSH PORT : $nowport

    [ 1 ] Reset to default SSH Port 22
    [ 2 ] Use Random SSH Port
    [ 3 ] Custome SSH Port

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp '↘️  Type Number | Press [ENTER]: ' port </dev/tty
  case $port in
     1) defaultport ;;
     2) randomport ;;
     3) customeport ;;
     *) clear && portchange ;;
  esac
}
ending() {
nowport=$(grep -P '^[#\s]*Port ' /etc/ssh/sshd_config | sed 's/[^0-9]*//g')
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Changed SSH PORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    Active SSH PORT : $nowport

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
}
portchange

#"G#