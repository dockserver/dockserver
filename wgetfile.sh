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
updates="update upgrade autoremove autoclean"
for upp in ${updates};do
    sudo $(command -v apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
##
sudo $(command -v apt) install lsb-release -yqq 1>/dev/null && clear
if [[ "$(lsb_release -cs)" == "xenial" ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━
⛔ Sorry this OS is not supported ⛔
━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit
fi
if [[ -f "/bin/dockserver" ]];then $(command -v rm) -rf /bin/dockserver;fi
if [[ -f "/usr/bin/dockserver" ]];then $(command -v rm) -rf /usr/bin/dockserver;fi
if [[ ! -x $(command -v git) ]];then sudo $(command -v apt) install git -yqq;fi
dockserver=/opt/dockserver
if [[ -d ${dockserver} ]];then
    $(command -v rm) -rf ${dockserver}
    git clone --quiet https://github.com/dockserver/dockserver.git ${dockserver}
else
    git clone --quiet https://github.com/dockserver/dockserver.git ${dockserver}
fi
file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
if [[ ! -x $(command -v rsync) ]];then $(command -v apt) install rsync -yqq;fi
if [[ -f "/bin/dockserver" ]];then $(command -v rm) $store && $(command -v rsync) $file $store -aqhv;fi
if [[ $EUID != 0 ]];then
    $(command -v chown) -R $(whoami):$(whoami) ${dockserver}
    $(command -v usermod) -aG sudo $(whoami)
    $(command -v chown) $(whoami):$(whoami) /bin/dockserver
fi
if [[ $EUID == 0 ]];then $(command -v chown) -R 1000:1000 ${dockserver} && $(command -v chown) 1000:1000 /bin/dockserver;fi
$(command -v chmod) 0775 /bin/dockserver
##
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ EASY MODE ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     to install dockserver
     [ sudo ] dockserver -i

     You want to see all Commands
     [ sudo ] dockserver -h
     [ sudo ] dockserver --help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
#EOF#