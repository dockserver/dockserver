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
##
if [[ -f "/bin/dockserver" ]];then $(command -v rm) -rf /bin/dockserver;fi
if [[ -f "/usr/bin/dockserver" ]];then $(command -v rm) -rf /usr/bin/dockserver;fi
if [[ ! -x $(command -v git) ]];then sudo $(command -v apt) install git -yqq;fi

##migrate from multirepo to one
old="/opt/apps /opt/gdsa /opt/traefik /opt/installer"
for i in ${old}; do
   sudo $(command -v rm) -rf $i
done
cat <<'EOF' >> /bin/dockserver
#!/bin/bash
####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
#####################################
# THE DOCKER ARE UNDER LICENSE      #
# NO CUSTOMIZING IS ALLOWED         #
# NO REBRANDING IS ALLOWED          #
# NO CODE MIRRORING IS ALLOWED      #
#####################################
# shellcheck disable=SC2086
# shellcheck disable=SC2006
if [[ $EUID != 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi
dockserver=/opt/dockserver
run() {
if [[ -d ${dockserver} ]];then 
   cd ${dockserver} && $(command -v bash) install.sh
else
   usage
fi
}
update() {
dockserver=/opt/dockserver
if [[ -d ${dockserver} ]];then
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ UPDATE ] STARTED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $(command -v rm) -rf ${dockserver} && git clone --quiet https://github.com/dockserver/dockserver.git ${dockserver}
    if [[ $EUID != 0 ]];then $(command -v chown) -R $(whoami):$(whoami) ${dockserver};fi
    if [[ $EUID == 0 ]];then $(command -v chown) -R 1000:1000 ${dockserver};fi
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ UPDATE ] DONE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
exit
fi
}
dev() {
dockserver=/opt/dockserver
if [[ -d ${dockserver} ]];then
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ DEV - CLONING ] STARTED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     $(command -v rm) -rf ${dockserver} && git clone --quiet -b dev https://github.com/dockserver/dockserver.git ${dockserver}
     if [[ $EUID != 0 ]];then $(command -v chown) -R $(whoami):$(whoami) ${dockserver};fi
     if [[ $EUID == 0 ]];then $(command -v chown) -R 1000:1000 ${dockserver};fi
     clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ DEV - CLONING ] DONE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
exit
fi
}

fork() {
dockserver=/opt/dockserver
DOCK=${DOCK}
FORK=${FORK}
if [[ ${DOCK} == "-f" || ${DOCK} == "--fork" ]];then
   if [[${FORK} != "" ]];then
       if [[ -d ${dockserver} ]];then
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer FORK Version Pull started"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     $(command -v rm) -rf ${dockserver}
     git clone --quiet ${FORK} ${dockserver}
     if [[ $EUID != 0 ]];then $(command -v chown) -R $(whoami):$(whoami) ${dockserver};fi
     if [[ $EUID == 0 ]];then $(command -v chown) -R 1000:1000 ${dockserver};fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer FORK Version Pull finished"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
       fi
   fi
fi
clear
}

usage() {
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ USAGE COMMANDS ]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   Commands :"
echo ""
echo "   dockserver -i / --install     =   open the dockserver setup"
echo "   dockserver -h / --help        =   help/usage"
echo "   dockserver -u / --update      =   update the local dockserver edition"
echo ""
echo "   dockserver -d / --dev         =   clone the dev branch of dockserver"
echo "   dockserver -f / --fork <link> =   run you own repo"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🚀    DockServer [ USAGE COMMANDS ]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit
}

DOCK=$1
FORK=$2
case "$DOCK" in
 "" ) run ;;
 "-i" ) run ;;
 "--install" ) run ;;
 "-u" ) update ;;
 "--update" ) update ;;
 "-h" ) usage ;;
 "--help" ) usage ;;
 "-d" ) dev ;;
 "--dev" ) dev ;;
 "-f" ) fork ;;
 "--fork" ) fork ;;
esac
#EOF
EOF
dockserver=/opt/dockserver
if [[ -d ${dockserver} ]];then
    $(command -v rm) -rf ${dockserver}
    git clone --quiet https://github.com/dockserver/dockserver.git ${dockserver}
else
    git clone --quiet https://github.com/dockserver/dockserver.git ${dockserver}
fi
if [[ $EUID != 0 ]];then
    $(command -v chown) -R $(whoami):$(whoami) ${dockserver}
    $(command -v usermod) -aG sudo $(whoami)
    $(command -v chown) $(whoami):$(whoami) /bin/dockserver
fi
if [[ $EUID == 0 ]];then
    $(command -v chown) -R 1000:1000 ${dockserver}
    $(command -v chown) 1000:1000 /bin/dockserver
fi
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
