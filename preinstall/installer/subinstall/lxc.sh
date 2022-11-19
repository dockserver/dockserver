#!/bin/bash
#
# Title:      LXC Bypass the mount :shared
# OS Branch:  ubuntu,debian,rasbian
# Author(s):  mrdoob
# Coauthor:   DrAgOn141
# GNU:        General Public License v3.0
################################################################################
# shellcheck disable=SC2003
# shellcheck disable=SC2006
# shellcheck disable=SC2207
# shellcheck disable=SC2012
# shellcheck disable=SC2086
# shellcheck disable=SC2196
# shellcheck disable=SC2046
#FUNCTIONS
LXC() {
  if [[ ! -x $(command -v rsync) ]]; then $(command -v apt) install --reinstall rsync -yqq 1>/dev/null 2>&1; fi
  if [[ ! -f "/home/.lxcstart.sh" ]]; then $(command -v rsync) -aqhv /opt/dockserver/preinstall/installer/subinstall/lxcstart.sh /home/.lxcstart.sh; fi
  if [[ -f "/home/.lxcstart.sh" ]]; then
    $(command -v chmod) a=rx,u+w /home/.lxcstart.sh
    $(command -v bash) /home/.lxcstart.sh
    $(command -v ansible-playbook) /opt/dockserver/preinstall/installer/subinstall/lxc.yml 1>/dev/null 2>&1
  fi
  ## set cron.d
  if [[ -f "/home/.lxcstart.sh" ]]; then $(command -v ansible-playbook) /opt/dockserver/preinstall/installer/subinstall/lxc.yml 1>/dev/null 2>&1; fi
  if [[ ! -f "/etc/cron.d/lxcstart" ]]; then
    echo -n "
SHELL=/bin/bash
@reboot root /bin/bash /home/.lxcstart.sh 1>/dev/null 2>&1" >>/etc/cron.d/lxcstart
    $(command -v chmod) a=rx,u+w /etc/cron.d/lxcstart
    sleep 1
  fi
  ending && clear && exit
}
ending() {
  printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ INFO
    Please be sure that you have add the following features
    keyctl, nesting and fuse under LXC Options > Features,
    this is only available when Unprivileged container=Yes
    The mount-docker takes round about 2 minutes to start
    after the installation, please be patient
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
  read -erp "Confirm Info | Type confirm & PRESS [ENTER]" input </dev/tty
  if [[ "$input" = "confirm" ]]; then clear; else ending; fi
}
while true; do
  if [[ "$(systemd-detect-virt)" != "lxc" ]]; then exit; else LXC; fi
done
#"
