#!/bin/sh
df -H | grep -vE '^Filesystem|tmpfs|cdrom|overlay|udev|/dev/md1|mergerfs|remote' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date), cleaning up /mnt/downloads/nzb folders older than 1 hour, cleaning up /mnt/nzb/ files older than 7 days" &&
    find /mnt/downloads/nzb/* -type d -mmin +240 -exec rm -rf {} \; >/dev/null 2>&1 &&
    find /mnt/nzb/* -type f -mmin +10080 -exec rm -rf {} \; >/dev/null 2>&1
else
       echo "disk not out of space"
  fi
done
