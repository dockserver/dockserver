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
export logfile=/opt/appdata/traefik/traefik.log
while true;do
  tail -n 15 "${logfile}" | grep --line-buffered '/_ignition/execute-solution' | sed '/banned/d' | awk '{print $1}'  | while read line; do
     iptables -A INPUT -s $line -j DROP
     sed -i "s#$line#banned#g" "${logfile}"
     sleep 5
  done
  tail -n 50 "${logfile}" | grep --line-buffered '/?x=${jndi:' | sed '/banned/d' | awk '{print $1}'  | while read line; do
     iptables -A INPUT -s $line -j DROP
     sed -i "s#$line#banned#g" "${logfile}"
     sleep 5
  done
 sleep 5
done
