#!/usr/bin/with-contenv bash
# shellcheck shell=bash

cleannzb=/mnt/nzb
cleandownload=/mnt/downloads/nzb

df -H | grep -vE '^Filesystem|tmpfs|cdrom|overlay|udev|/dev/md1|/dev/md127|/dev/md2|mergerfs|remote' | awk '{ print $5 " " $1 }' | while read output; do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{ print $2 }')
  if [ $usep -ge 75 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date), cleaning up $cleandownload folders older than 1 hour, cleaning up $cleannzb files older than 7 days" &&
      $(command -v find) $cleandownload/* -type d -mmin +240 -exec rm -rf {} \; >/dev/null 2>&1 &&
      $(command -v find) $cleannzb/* -type f -mmin +10080 -exec rm -rf {} \; >/dev/null 2>&1
  else
    echo "disk not out of space"
  fi
done
