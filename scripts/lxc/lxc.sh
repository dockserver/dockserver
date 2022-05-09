#!/bin/bash
####################################
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
# shellcheck disable=SC2086
# shellcheck disable=SC2046

function log() {
   echo "[INSTALL] DockServer ${1}"
}

function runcreate() {

$(which mkdir) -p /opt/lxc
cat > /opt/lxc/.lxcstart.sh << EOF; $(echo)
#!/bin/bash
#
# Title:      LXC Bypass the mount :shared
# OS Branch:  ubuntu,debian,rasbian
# Author(s):  mrdoob
# Coauthor:   DrAgOn141
# GNU:        General Public License v3.0
################################################################################
## make / possible to add /mnt:shared
mount --make-shared /
EOF

}

function lxcending() {
printf "%1s\n" "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ INFO
    Please be sure that you have add the following features
    keyctl, nesting and fuse under LXC Options > Features,
    this is only available when Unprivileged container=Yes
    The mount-docker takes round about 2 minutes to start
    after the installation, please be patient
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  read -erp "Confirm Info | Type confirm & PRESS [ENTER]" input </dev/tty
}

runcreate
 $(which chmod) a=rx,u+w /opt/lxc/.lxcstart.sh
   $(which bash) /opt/lxc/.lxcstart.sh
     $(which crontab) -l > cron_bkp
       $(which echo) "@reboot root /bin/bash /opt/lxc/.lxcstart.sh 1>/dev/null 2>&1" >> cron_bkp
         $(which crontab) cron_bkp
           $(which rm) cron_bkp
             lxcending && clear && exit

