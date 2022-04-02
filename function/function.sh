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

function preinstall() {
# shellcheck disable=SC2046
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install Runs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
     case $(. /etc/os-release && echo "$ID") in
        ubuntu|debian|raspian) type="ubuntu"
           aptcommand="apt" \
           aptupdate="update" \
           aptupgrade="upgrade" ;; 
        *) type='' && exit 0 ;
     esac


     basefolder="/opt/appdata"
     proxydel      
     packageupdate="update upgrade dist-upgrade autoremove autoclean"
     for i in ${packageupdate}; do $(which apt) $i -yqq ; done
     package_basic=(software-properties-common rsync language-pack-en-base pciutils lshw nano rsync fuse curl wget tar pigz pv iptables ipset fail2ban jq unzip)
     $(which ${aptcommand}) install ${package_basic[@]} --reinstall -yqq

     fastapp

     docker-create
 
     if test -f /etc/sysctl.d/99-sysctl.conf; then
         config="/etc/sysctl.d/99-sysctl.conf"
         ipv6=$(cat $config | grep -qE 'ipv6' && echo true || false)
           if [ $ipv6 != 'true' ] || [ $ipv6 == 'true' ]; then
              grep -qE 'net.ipv6.conf.all.disable_ipv6 = 1' $config || \
              echo 'net.ipv6.conf.all.disable_ipv6 = 1' >>$config
              grep -qE 'net.ipv6.conf.default.disable_ipv6 = 1' $config || \
              echo 'net.ipv6.conf.default.disable_ipv6 = 1' >>$config
              grep -qE 'net.ipv6.conf.lo.disable_ipv6 = 1' $config || \
              echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >>$config
              grep -qE 'net.core.default_qdisc=fq' $config || \
              echo 'net.core.default_qdisc=fq' >>$config
              grep -qE 'net.ipv4.tcp_congestion_control=bbr' $config || \
              echo 'net.ipv4.tcp_congestion_control=bbr' >>$config
              sysctl -p -q
           fi
      fi
      ## USE OFFICIAL DOCKER INSTALL PART
      if [[ ! $(which docker) ]]; then wget -qO- https://get.docker.com/ | sh >/dev/null 2>&1 ; fi
         daemonjson
         $(which usermod) -aG docker $(whoami)
         $(which systemctl) reload-or-restart docker.service 1>/dev/null 2>&1
         $(which systemctl) enable docker.service >/dev/null 2>&1
         $(which curl) --silent -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | bash 1>/dev/null 2>&1
         $(which docker) volume create -d local-persist -o mountpoint=/mnt --name=unionfs
         $(which docker) network create --driver=bridge proxy 1>/dev/null 2>&1

      updatecompose && gpupart

      disable=(apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service)
      $(which systemctl) disable ${disable[@]} >/dev/null 2>&1

      if [[ ! $(which ansible) ]]; then
         if [[ -r /etc/os-release ]]; then lsb_dist="$(. /etc/os-release && echo "$ID")"; fi
         package_list="ansible dialog python3-lxml"
         package_listdebian="apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367"
         package_listubuntu="apt-add-repository --yes --update ppa:ansible/ansible"
         if [[ $lsb_dist == 'ubuntu' ]] || [[ $lsb_dist == 'rasbian' ]]; then ${package_listubuntu} 1>/dev/null 2>&1; else ${package_listdebian} 1>/dev/null 2>&1; fi
         for i in ${package_list}; do
            $(which apt) install $i --reinstall -yqq 1>/dev/null 2>&1
         done
         if [[ $lsb_dist == 'ubuntu' ]]; then add-apt-repository --yes --remove ppa:ansible/ansible; fi
      fi

      if [[ ! -d "/etc/ansible/inventories" ]]; then $(which mkdir) -p $invet ; fi
      cat > /etc/ansible/inventories/local << EOF; $(echo)
## CUSTOM local inventories
[local]
127.0.0.1 ansible_connection=local
EOF
      if test -f /etc/ansible/ansible.cfg; then
        $(which mv) /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.bak
      fi
cat > /etc/ansible/ansible.cfg << EOF; $(echo)
## CUSTOM Ansible.cfg
[defaults]
deprecation_warnings = False
command_warnings = False
force_color = True
inventory = /etc/ansible/inventories/local
retry_files_enabled = False
EOF

      if [[ "$(systemd-detect-virt)" == "lxc" ]]; then lxc ; fi

      while true; do
         f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
         if [[ $f2ban != 'true' ]]; then echo "Waiting for fail2ban to start" && sleep 1 && continue; else break; fi
      done

      ORGFILE="/etc/fail2ban/jail.conf"
      LOCALMOD="/etc/fail2ban/jail.local"
cat > /etc/fail2ban/filter.d/log4j-jndi.conf << EOF; $(echo)
# jay@gooby.org
# https://jay.gooby.org/2021/12/13/a-fail2ban-filter-for-the-log4j-cve-2021-44228
# https://gist.github.com/jaygooby/3502143639e09bb694e9c0f3c6203949
# Thanks to https://gist.github.com/kocour for a better regex
[log4j-jndi]
maxretry = 1
enabled = true
port = 80,443
logpath = /opt/appdata/traefik/traefik.log
EOF

cat > /etc/fail2ban/filter.d/authelia.conf << EOF; $(echo)
[authelia]
enabled = true
port = http,https,9091
filter = authelia
logpath = /opt/appdata/authelia/authelia.log
maxretry = 2
bantime = 90d
findtime = 7d
chain = DOCKER-USER
EOF
grep -qE '#log4j
[Definition]
failregex   = (?i)^<HOST> .* ".*\$.*(7B|\{).*(lower:)?.*j.*n.*d.*i.*:.*".*?$' /etc/fail2ban/jail.local || \
 echo '#log4j
[Definition]
failregex   = (?i)^<HOST> .* ".*\$.*(7B|\{).*(lower:)?.*j.*n.*d.*i.*:.*".*?$' > /etc/fail2ban/jail.local
         sed -i "s#rotate 4#rotate 1#g" /etc/logrotate.conf
         sed -i "s#weekly#daily#g" /etc/logrotate.conf

      f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
      if [[ $f2ban != "false" ]]; then
         $(which systemctl) reload-or-restart fail2ban.service 1>/dev/null 2>&1
         $(which systemctl) enable fail2ban.service 1>/dev/null 2>&1
      fi

      ## raiselimits
      sed -i '/hard nofile/ d' /etc/security/limits.conf
      sed -i '/soft nofile/ d' /etc/security/limits.conf
      sed -i '$ i\* hard nofile 32768\n* soft nofile 16384' /etc/security/limits.conf
      printf "%1s\n" "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
clear
}

function daemonjson() {

echo '{
    "storage-driver": "overlay2",
    "userland-proxy": false,
    "dns": ["8.8.8.8", "1.1.1.1"],
    "ipv6": false,
    "log-driver": "json-file",
    "live-restore": true,
    "log-opts": {"max-size": "8m", "max-file": "2"}
}' >/etc/docker/daemon.json

}

function badips() {
   #bad ips mod
   ipset -q flush ips
   ipset -q create ips hash:net
   for ip in $(curl --compressed https://raw.githubusercontent.com/scriptzteam/IP-BlockList-v4/master/ips.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do ipset add ips $ip; done
   $(which iptables) -I INPUT -m set --match-set ips src -j DROP
   update-locale LANG=LANG=LC_ALL=en_US.UTF-8 LANGUAGE 1>/dev/null 2>&1
   localectl set-locale LANG=LC_ALL=en_US.UTF-8 1>/dev/null 2>&1
}

function proxydel() {
   delproxy="apache2 nginx"
   for i in ${delproxy}; do
      $(which systemctl) stop $i 1>/dev/null 2>&1
      $(which systemctl) disable $i 1>/dev/null 2>&1
      $(which apt) remove $i -yqq 1>/dev/null 2>&1
      $(which apt) purge $i -yqq 1>/dev/null 2>&1
      break
   done
}

function lxc() {
    lxcstart
    $(which chmod) a=rx,u+w /home/.lxcstart.sh
    $(which  bash) /home/.lxcstart.sh
    lxcansible
    $(which ansible-playbook) /home/.lxcplaybook.yml 1>/dev/null 2>&1
cat > /etc/cron.d/lxcstart << EOF; $(echo)
SHELL=/bin/bash
@reboot root /bin/bash /home/.lxcstart.sh 1>/dev/null 2>&1
EOF
    $(command -v chmod) a=rx,u+w /etc/cron.d/lxcstart
    lxcending && clear
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

function lxcansible() {
cat > /home/.lxcplaybook.yml << EOF; $(echo)
---
- hosts: localhost
  gather_facts: false
  name: LXC Playbook
  tasks:
    - cron:
        name: LXC Bypass the mount :shared
        special_time: 'reboot'
        user: root
        job: '/bin/bash /home/.lxcstart.sh 1>/dev/null 2>&1'
        state: present
      become_user: root
      ignore_errors: yes
EOF
}

function lxcstart() {
cat > /home/.lxcstart.sh << EOF; $(echo)
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

function gpupart() {
GVID=$(id $(whoami) | grep -qE 'video' && echo true || echo false)
GCHK=$(grep -qE video /etc/group && echo true || echo false)
DEVT=$(ls /dev/dri 1>/dev/null 2>&1 && echo true || echo false)
IGPU=$(ls /etc/modprobe.d/ | grep -qE 'hetzner*' && echo true || echo false)
NGPU=$(lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E 'NVIDIA' 1>/dev/null 2>&1 && echo true || echo false)
OSVE=$(./etc/os-release | echo $ID)
DIST=$(./etc/os-release | echo $ID$VERSION_ID)
VERS=$(./etc/os-release | echo $UBUNTU_CODENAME)

if [[ $IGPU == "true" && $NGPU == "false" ]]; then
   igpuhetzner
elif [[ $NGPU == "true" && $IGPU == "true" ]]; then
     nvidiagpu
elif [[ $NGPU == "true" && $IGPU == "false" ]]; then
     nvidiagpu
else 
    echo ""
fi
}

function endcommand() {
    if [[ $DEVT != "false" ]]; then
        $(which chmod) -R 750 /dev/dri
    else
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You need to restart the server to get access to /dev/dri
after restarting execute the install again

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
        read -p "Type confirm to reboot: " input
        if [[ "$input" = "confirm" ]]; then reboot -n; else endcommand; fi
    fi
}

function subos() {
    NSO=$(curl -s -L https://nvidia.github.io/nvidia-docker/$DIST/nvidia-docker.list)
    NSOE=$(echo ${NSO} | grep -E 'Unsupported')
    if [[ $NSOE != "" ]]; then
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      NVIDIA ❌ ERROR
      NVIDIA don't support your running Distribution
      Installed Distribution = ${DIST}
      Please visit the link below to see all supported Distributionen
      NVIDIA ❌ ERROR
      ${NSO}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
        read -erp "Confirm Info | Type confirm & PRESS [ENTER]" input </dev/tty
        if [[ "$input" = "confirm" ]]; then clear; else subos; fi
    fi
}

function igpuhetzner() {
HMOD=$(ls /etc/modprobe.d/ | grep -qE 'hetzner' && echo true || echo false)
ITEL=$(cat /etc/modprobe.d/blacklist-hetzner.conf | grep -qE '#blacklist i915' && echo true || echo false)
IMOL1=$(cat /etc/default/grub | grep -qE '#GRUB_CMDLINE_LINUX_DEFAULT' && echo true || echo false)
IMOL2=$(cat /etc/default/grub.d/hetzner.cfg | grep -qE '#GRUB_CMDLINE_LINUX_DEFAULT' && echo true || echo false)
INTE=$(ls /usr/bin/intel_gpu_* 1>/dev/null 2>&1 && echo true || echo false)
VIFO=$(which vainfo 1>/dev/null 2>&1 && echo true || echo false)

if [[ $HMOD == "false" ]]; then exit; fi
if [[ $ITEL == "false" ]]; then sed -i "s/blacklist i915/#blacklist i915/g" /etc/modprobe.d/blacklist-hetzner.conf; fi
if [[ $IMOL1 == "false" ]]; then sed -i "s/GRUB_CMDLINE_LINUX_DEFAUL/#GRUB_CMDLINE_LINUX_DEFAUL/g" /etc/default/grub; fi
if [[ $IMOL2 == "false" ]]; then sed -i "s/GRUB_CMDLINE_LINUX_DEFAUL/#GRUB_CMDLINE_LINUX_DEFAUL/g" /etc/default/grub.d/hetzner.cfg; fi
if [[ $OSVE == "ubuntu" && $VERS == "focal" ]]; then
   if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" ]]; then sudo update-grub; fi
else
   if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" ]]; then sudo grub-mkconfig -o /boot/grub/grub.cfg; fi
fi
if [[ $GCHK == "false" ]]; then groupadd -f video; fi
if [[ $GVID == "false" ]]; then usermod -aG video $(whoami); fi
   endcommand
if [[ $VIFO == "false" ]]; then $(command -v apt) install vainfo -yqq; fi
if [[ $INTE == "false" && $IGPU == "true" ]]; then $(command -v apt) update -yqq && $(command -v apt) install intel-gpu-tools -yqq; fi
if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" && $GVID == "true" && $DEVT == "true" ]]; then echo "Intel IGPU is working"; else echo "Intel IGPU is not working"; fi
}


function nvidiagpu() {

VERSION=510.54
RCHK=$(ls /etc/apt/sources.list.d/ 1>/dev/null 2>&1 | grep -qE 'nvidia' && echo true || echo false)
DREA=$(pidof dockerd 1>/dev/null 2>&1 && echo true || echo false)
CHKN=$(which nvidia-smi 1>/dev/null 2>&1 && echo true || echo false)
DCHK=$(cat /etc/docker/daemon.json | grep -qE 'nvidia' && echo true || echo false)

subos

if [[ ! -f "/opt/nvidia/nvidia.run" ]]; then
   $(which mkdir) /opt/nvidia && \
   $(which wget) -O /opt/nvidia/nvidia.run https://international.download.nvidia.com/XFree86/Linux-x86_64/$VERSION/NVIDIA-Linux-x86_64-$VERSION.run && \
   $(which chmod) +x ./nvidia.run && \
   ./opt/nvidia/nvidia.run --dkms --silent
   if test -f "/opt/nvidia/nvidia.run"; then
      $(which rm) -rf /opt/nvidia/nvidia.run
   fi
fi

if [[ $RCHK == "false" ]]; then
   $(which apt) install $(apt-cache search 'nvidia-driver-' | grep '^nvidia-driver-[[:digit:]]*' | tail -n1 | awk '{print $1}') -y
   $(which curl) -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
     apt-key add -
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   $(which curl) -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
     tee /etc/apt/sources.list.d/nvidia-container-runtime.list
   $(which apt) update -y && \
   $(which apt) install nvidia-container-runtime nvidia-container-toolkit -y
fi

if [[ $DCHK == "false" ]]; then
$(which mkdir) -p /etc/systemd/system/docker.service.d
$(which tee) /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF
$(which systemctl) daemon-reload && $(which systemctl) restart docker
$(which tee) /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
$(which pkill) -SIGHUP dockerd
fi

if [[ ! -d "/opt/nvidia/libnvidia-encode-backup" ]];then
   $(which wget) -O /opt/nvidia/nvidia-patch.sh https://raw.githubusercontent.com/keylase/nvidia-patch/master/patch.sh && \
   chmod +x /opt/nvidia/nvidia-patch.sh && |
   ./opt/nvidia/nvidia-patch.sh
   if test -f "/opt/nvidia/nvidia-patch.sh"; then
      $(which rm) -rf /opt/nvidia/nvidia-patch.sh
   fi
fi

if [[ $(which nvidia-smi) ]];then
   SHOW=$(nvidia-smi)
printf "%1s\n" "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      NVIDIA OUTPUT
   ${SHOW}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
fi

if [[ $GVID == "false" ]]; then usermod -aG video $(whoami); fi
if [[ $DREA == "true" ]]; then pkill -SIGHUP dockerd; fi
    endcommand
if [[ $DREA == "true" && $DCHK == "true" && $CHKN == "true" && $DEVT != "false" ]]; then echo "nvidia-container-runtime is working"; else echo "nvidia-container-runtime is not working"; fi
}

function run() {
if [ ! $(which docker) ] && [ ! $(which docker-compose) ] && [ ! $(docker --version) ]; then
   preinstall
fi

if [[ -d ${dockserver} ]];then
   envmigra && fastapt && cleanup && clear && appstartup
else
   usage
fi
}

function update() {
dockserver=/opt/dockserver
clear
printf "%1s\n" "${yellow}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ UPDATE CONTAINER ] STARTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
     basefolder="/opt/appdata"
     compose="compose/docker-compose.yml"
     $(which rsync) ${dockserver}/dockserver/docker.yml $basefolder/$compose -aqhv
     if [[ -f $basefolder/$compose ]];then
        $(which cd) $basefolder/compose/ && \
          $(which docker-compose) config 1>/dev/null 2>&1 && \
            $(which docker-compose) down 1>/dev/null 2>&1 && \
            $(which docker-compose) up -d --force-recreate 1>/dev/null 2>&1
     fi
     $(which chown) -cR 1000:1000 ${dockserver} 1>/dev/null 2>&1
     envmigra && fastapt && cleanup && clear
printf "%1s\n" "${yellow}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ UPDATE CONTAINER ] DONE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

}

function fastapp() {
APP=${APP}
for i in ${APP[@]} ; do
    $(which find) /opt/dockserver/apps/ -mindepth 1 -type f -name "${i}*" -exec dirname {} \; | while read rename; do
      section="${rename#*/opt/dockserver/apps/}"                                  
      typed=$i
      if test -f /opt/dockserver/apps/$section/$i.yml; then
         source /opt/dockserver/function/function.sh
         typed=${typed}
         section=${section}
         runinstall
      fi
    done
done
}

function recon(){

APP=${APP}
for rec in ${APP[@]} ; do
printf "%1s\n" "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Reconnect $rec to the docker network 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
    docker stop $rec &>/dev/null
    docker network disconnect proxy $rec &>/dev/null
    docker network connect proxy $rec &>/dev/null
    docker start $rec &>/dev/null
printf "%1s\n" "${green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Starting now $rec
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
done
}

####
function usage() {
clear
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Dockserver  [ USAGE COMMANDS ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Commands :

   dockserver -i / --install     =   open the dockserver setup
   dockserver -u / --update      =   deployed the update container

   dockserver -a / --app <{NAMEOFAPP}>  =   fast app installation
 
   dockserver -r / --reconnect   =   reconnect docker to the network
   dockserver -p / --preinstall  =   run preinstall parts for dockserver

   dockserver -h / --help        =   help/usage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ USAGE COMMANDS ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

}

function envmigra() {
basefolder="/opt/appdata"
dockserver="/opt/dockserver"
envmigrate="$dockserver/apps/.subactions/envmigrate.sh"
if [[ -f "$basefolder/compose/.env" ]];then
   $(which bash) $envmigrate
fi 
}

function fastapt() {
if ! type aria2c >/dev/null 2>&1; then
   $(which apt) update -yqq && \
   $(which apt) install --force-yes -yqq aria2
fi
if [[ ! -f /etc/apt-fast.conf ]]; then
   $(which bash) -c "$(curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"
   echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
   echo debconf apt-fast/dlflag boolean true | debconf-set-selections
   echo debconf apt-fast/aptmanager string apt | debconf-set-selections
fi
}

function appstartup() {
     dockertraefik=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -E 'traefik')
     ntdocker=$(docker network ls | grep -E 'proxy')
  if [[ $ntdocker == "" && $dockertraefik == "" ]]; then
     unset ntdocker && unset dockertraefik
     preinstall
  else
     unset ntdocker && unset dockertraefik
     clear && headinterface
  fi
}

function updatebin() {
file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
store2=/usr/bin/dockserver
if [[ -f "/bin/dockserver" ]];then
   $(which rm) $store && \
   $(which rsync) $file $store -aqhv
   $(which rsync) $file $store2 -aqhv
   $(which chown) -R 1000:1000 $store $store2
   $(which chmod) -R 755 $store $store2
fi
}

function folderunmount() {

for fod in /mnt/* ;do
  basename "$fod" >/dev/null
  FOLDER="$(basename -- $fod)"
  IFS=- read -r <<< "$ACT"
  if ! ls -1p "$fod/" >/dev/null ; then
     $(which fusermount) -uzq /mnt/$FOLDER
  fi
done

}

function headinterface() {
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    [ 1 ] DockServer - Traefik + Authelia
    [ 2 ] DockServer - Applications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1|traefik) clear && traefik ;;
    2|apps|app) clear && headapps ;;
    Z|z|exit|EXIT|Exit|close) updatebin && exit ;;
    *) clear && headapps ;;
  esac
}

function traefik() {
installed=$($(which docker) ps -aq --format '{{.Names}}' | grep -x 'traefik')
if [[ $installed == "" ]]; then
   overwrite
else
   useraction
fi
}

function useraction() {
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [ Y ] Force Reset         ( clean Deploy )
  [ N ] No, its a mistake   ( Back to Head Menu )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "Are you sure ?: " uaction </dev/tty
   case $uaction in
      y|Y|yes) clear && overwrite ;;
      n|N|no) clear && headinterface ;;
      Z|z|c|exit|EXIT|Exit|close) headinterface ;;
      *) useraction ;;
   esac
}
function overwrite() {
   basefolder="/opt/appdata"
   source="/opt/dockserver/traefik/templates/"
   for i in ${basefolder}; do
      container=$($(which docker) ps -aq --format '{{.Names}}' | grep -E 'trae|auth|error-pag')
      for i in ${container}; do
          $(which docker) stop $i 1>/dev/null 2>&1
          $(which docker) rm $i 1>/dev/null 2>&1
          $(which docker) image prune -af 1>/dev/null 2>&1
      done
      $(which rm) -rf $i/{authelia,traefik,compose}
      $(which mkdir) -p $i/{authelia,traefik,compose} $i/traefik/{rules,acme}
      $(which find) $i/{authelia,traefik} -exec $(command -v chown) -hR 1000:1000 {} \;
      $(which touch) $i/traefik/acme/acme.json $i/traefik/traefik.log $i/authelia/authelia.log
      $(which chmod) 600 $i/traefik/traefik.log $i/authelia/authelia.log $i/traefik/acme/acme.json
   done
   $(command -v rsync) ${source} ${basefolder} -aqhv --exclude={'local','installer'}
   envmigra
   traefikinterface
}

function domain() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Treafik Domain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     DNS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     DNS records will not be automatically added
           with the following TLD Domains
           .a, .cf, .ga, .gq, .ml or .tk
     Cloudflare has limited their API so you
          will have to manually add these
   records yourself via the Cloudflare dashboard.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "Which domain would you like to use?: " DOMAIN </dev/tty
   if [[ $DOMAIN == "" ]]; then
      echo "Domain cannot be empty"
      domain
   else
      MODIFIED=$(cat /etc/hosts | grep $DOMAIN && echo true || echo false)
      if [[ $MODIFIED == "false" ]]; then
         echo "\
127.0.0.1  *.$DOMAIN
127.0.0.1  $DOMAIN" | tee -a /etc/hosts > /dev/null
      fi
      if [[ $DOMAIN != "example.com" ]]; then
         if [[ $(uname) == "Darwin" ]]; then
            sed -i '' "s/example.com/$DOMAIN/g" $basefolder/authelia/configuration.yml
            sed -i '' "s/example.com/$DOMAIN/g" $basefolder/traefik/rules/middlewares.toml
            sed -i '' "s/example.com/$DOMAIN/g" $basefolder/compose/.env
         else
            sed -i "s/example.com/$DOMAIN/g" $basefolder/authelia/configuration.yml
            sed -i "s/example.com/$DOMAIN/g" $basefolder/traefik/rules/middlewares.toml
            sed -i "s/example.com/$DOMAIN/g" $basefolder/compose/.env
         fi
      fi
   fi
   clear && traefikinterface
}

function displayname() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Authelia Username
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "Enter your username for Authelia (eg. John Doe): " DISPLAYNAME </dev/tty
   if [[ $DISPLAYNAME != "" ]]; then
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/<DISPLAYNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
         sed -i '' "s/<USERNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
      else
         sed -i "s/<DISPLAYNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
         sed -i "s/<USERNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
      fi
   else
      echo "Display name cannot be empty"
      displayname
   fi
   clear && traefikinterface
}

function password() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Authelia Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "Enter a password for $USERNAME: " PASSWORD </dev/tty
   if [[ $PASSWORD != "" ]]; then
      $(command -v docker) pull authelia/authelia -q >/dev/null
      PASSWORD=$($(command -v docker) run authelia/authelia authelia hash-password $PASSWORD -i 2 -k 32 -m 128 -p 8 -l 32 | sed 's/Password hash: //g')
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/<PASSWORD>/$(echo $PASSWORD | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/users_database.yml
      else
         sed -i "s/<PASSWORD>/$(echo $PASSWORD | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/users_database.yml
      fi
   else
      echo "Password cannot be empty"
      password
   fi
   clear && traefikinterface
}

function cfemail() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Email-Address
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "What is your CloudFlare Email Address : " EMAIL </dev/tty
   if [[ $EMAIL != "" ]]; then
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/CF-EMAIL/$EMAIL/g" $basefolder/authelia/{configuration.yml,users_database.yml}
         sed -i '' "s/CF-EMAIL/$EMAIL/g" $basefolder/compose/.env
      else
         sed -i "s/CF-EMAIL/$EMAIL/g" $basefolder/authelia/{configuration.yml,users_database.yml}
         sed -i "s/CF-EMAIL/$EMAIL/g" $basefolder/compose/.env
      fi
   else
      echo "CloudFlare Email Address cannot be empty"
      cfemail
   fi
   clear && traefikinterface
}

function cfkey() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Global-Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "What is your CloudFlare Global Key: " CFGLOBAL </dev/tty
   if [[ $CFGLOBAL != "" ]]; then
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/authelia/configuration.yml
         sed -i '' "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/compose/.env
      else
         sed -i "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/authelia/configuration.yml
         sed -i "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/compose/.env
      fi
   else
      echo "CloudFlare Global Key cannot be empty"
      cfkey
   fi
   clear && traefikinterface
}
function cfzoneid() {
   basefolder="/opt/appdata"
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Zone-ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   read -erp "Whats your CloudFlare Zone ID: " CFZONEID </dev/tty
   if [[ $CFZONEID != "" ]]; then
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/CF-ZONE_ID/$CFZONEID/g" $basefolder/compose/.env
      else
         sed -i "s/CF-ZONE_ID/$CFZONEID/g" $basefolder/compose/.env
      fi
   else
      echo "CloudFlare Zone ID cannot be empty"
      cfzoneid
   fi
   clear && traefikinterface
}

function jounanctlpatch() {
   CTPATCH=$(cat /etc/systemd/journald.conf | grep "#PATCH" && echo true || echo false)
   if [[ $CTPATCH == "false" ]]; then
      journalctl --flush 1>/dev/null 2>&1
      journalctl --rotate 1>/dev/null 2>&1
      journalctl --vacuum-time=1s 1>/dev/null 2>&1
      $(command -v find) /var/log -name "*.gz" -delete 1>/dev/null 2>&1
      echo "\
#PATCH
Storage=volatile
Compress=yes
SystemMaxUse=100M
SystemMaxFileSize=10M
SystemMaxFiles=1
MaxLevelStore=crit" | tee -a /etc/systemd/journald.conf > /dev/null
   fi
}

function serverip() {
   basefolder="/opt/appdata"
   SERVERIP=$(curl -s http://whatismijnip.nl | cut -d " " -f 5)
   if [[ $SERVERIP != "" ]]; then
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/SERVERIP_ID/$SERVERIP/g" $basefolder/authelia/configuration.yml
         sed -i '' "s/SERVERIP_ID/$SERVERIP/g" $basefolder/compose/.env
      else
         sed -i "s/SERVERIP_ID/$SERVERIP/g" $basefolder/authelia/configuration.yml
         sed -i "s/SERVERIP_ID/$SERVERIP/g" $basefolder/compose/.env
      fi
   fi
}

function timezone() {
   TZTEST=$($(command -v timedatectl) && echo true || echo false)
   TZONE=$($(command -v timedatectl) | grep "Time zone:" | awk '{print $3}')
   if [[ $TZTEST != "false" ]]; then
      if [[ $TZONE != "" ]]; then
         if [[ -f $basefolder/compose/.env ]]; then sed -i '/TZ=/d' $basefolder/compose/.env; fi
         TZ=$TZONE
         grep -qE 'TZ=$TZONE' $basefolder/compose/.env || \
         echo "TZ=$TZONE" >>$basefolder/compose/.env
      fi
   fi
}

function cleanup() {
   listexited=$($(command -v docker) ps -aq --format '{{.State}}' | grep -E 'exited' | awk '{print $1}')
   for i in ${listexited}; do
      $(command -v docker) rm $i 1>/dev/null 2>&1
   done
   $(command -v docker) image prune -af 1>/dev/null 2>&1
   $(which find) /var/log -type f -regex ".*\.gz$" -delete
   $(which find) /var/log -type f -regex ".*\.[0-9]$" -delete

}

function envcreate() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   env0=$basefolder/compose/.env
   if [[ -f $env0 ]]; then
      grep -qE 'ID=1000' $basefolder/compose/.env || \
      echo 'ID=1000' >>$basefolder/compose/.env
   fi
}

function secrets() {
   basefolder="/opt/appdata"
   JWTTOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
   if [[ $(uname) == "Darwin" ]]; then
      sed -i '' "s/JWTTOKENID/$(echo $JWTTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
    else
      sed -i "s/JWTTOKENID/$(echo $JWTTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   fi
   SECTOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
   if [[ $(uname) == "Darwin" ]]; then
      sed -i '' "s/unsecure_session_secret/$(echo $SECTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   else
      sed -i "s/unsecure_session_secret/$(echo $SECTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   fi
   ENCTOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
   if [[ $(uname) == "Darwin" ]]; then
      sed -i '' "s/encryption_key_secret/$(echo $ENCTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   else
      sed -i "s/encryption_key_secret/$(echo $ENCTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   fi
}

function certs() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   echo "Generating SSL certificate for *.$DOMAIN" && \
      $(command -v docker) pull authelia/authelia && \
      $(command -v docker) run -a stdout -v $basefolder/traefik/cert:/tmp/certs authelia/authelia authelia certificates generate --host *.${DOMAIN} --dir /tmp/certs/ > /dev/null
}

function deploynow() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   compose="compose/docker-compose.yml"
   envcreate && certs && secrets
   timezone && cleanup
   jounanctlpatch && serverip
   $(command -v cd) $basefolder/compose/
   if [[ -f $basefolder/$compose ]]; then
      $(which docker-compose) config 1>/dev/null 2>&1
      code=$?
      if [[ $code -ne 0 ]]; then
         printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR -> compose check has failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
         read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
         clear && traefikinterface
      fi
   fi
   if [[ -f $basefolder/$compose ]]; then
      $(which docker-compose) pull 1>/dev/null 2>&1
      code=$?
      if [[ $code -ne 0 ]]; then
         printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR -> compose pull has failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
         read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
         clear && traefikinterface
      fi
   fi
   if [[ -f $basefolder/$compose ]]; then
      $(which docker-compose) up -d --force-recreate 1>/dev/null 2>&1
      source $basefolder/compose/.env
      printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🚀   Treafik with Authelia
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 	   Treafik with Authelia is deployed
    Please Wait some minutes Authelia and Traefik
     need some minutes to start all services
     Access to the apps are only over https://

        Authelia:   https://authelia.${DOMAIN}
        Traefik:    https://traefik.${DOMAIN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      sleep 10
      read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
      clear && traefikinterface
   fi
}

function traefikinterface() {
   envmigra
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Treafik with Authelia over Cloudflare
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [1] Domain                         [ ${DOMAIN} ]
   [2] Authelia Username              [ $DISPLAYNAME ]
   [3] Authelia Password              [ $PASSWORD ]
   [4] Cloudflare-Email-Address       [ ${CLOUDFLARE_EMAIL} ]
   [5] Cloudflare-Global-Key          [ ${CLOUDFLARE_API_KEY} ]
   [6] Cloudflare-Zone-ID             [ ${DOMAIN1_ZONE_ID} ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [D] Deploy Treafik with Authelia
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

   read -erp '↘️  Type Number | Press [ENTER]: ' headtyped </dev/tty
   case $headtyped in
   1) domain ;;
   2) displayname ;;
   3) password ;;
   4) cfemail ;;
   5) cfkey ;;
   6) cfzoneid ;;
   d | D) deploynow ;;
   Z | z | exit | EXIT | Exit | close) headinterface ;;
   *) clear && traefikinterface ;;
   esac
}

function headapps() {
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  DockServer Applications Section Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] Install  Apps
    [ 2 ] Remove   Apps
    [ 3 ] Backup   Apps
    [ 4 ] Restore  Apps

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1|install|insta) clear && appinterface ;;
    2|remove|delete) clear && removeapp ;;
    3|backup|back) clear && backupstorage ;;
    4|restore|rest) clear && restorestorage ;;
    Z|z|exit|EXIT|Exit|close) headinterface ;;
    *) headapps ;;
  esac
}

function appinterface() {
buildshow=$(ls -1p /opt/dockserver/apps/ | grep '/$' | $(command -v sed) 's/\/$//')
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Applications Category Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$buildshow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

  read -erp "↘️  Type Section Name and Press [ENTER]: " section </dev/tty
  case $section in
     Z|z|exit|EXIT|Exit|close) headapps ;;
     *) checksection=$(ls -1p /opt/dockserver/apps/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $section) && \
     if [[ $checksection == $section ]];then clear && install ; else appinterface; fi ;;
  esac
}

function install() {
restorebackup=null
section=${section}
buildshow=$(ls -1p /opt/dockserver/apps/${section}/ | sed -e 's/.yml//g' )
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Applications to install under ${section} category
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$buildshow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  read -erp "↪️ Type App-Name to install and Press [ENTER]: " typed </dev/tty
  case $typed in
    Z|z|exit|EXIT|Exit|close) headapps ;;
    *) buildapp=$(ls -1p /opt/dockserver/apps/${section}/ | $(command -v sed) -e 's/.yml//g' | grep -x $typed) && \
       if [[ $buildapp == $typed ]];then clear && runinstall && install; else install; fi ;;
  esac

}

### backup docker ###
function backupstorage() {
storagefolder=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//')
if [[ $storagefolder == "" ]];then 
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 You need to set a backup folder
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  case $storage in
     Z|z|exit|EXIT|Exit|close) headapps ;;
     *) if [[ $storage != "" ]];then $(command -v mkdir) -p /mnt/unionfs/appbackups/${storage};fi && \
           teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage) && \
        if [[ $teststorage == $storage ]];then backupdocker;fi ;;
  esac
else
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$storagefolder

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  case $storage in
    Z|z|exit|EXIT|Exit|close) headapps ;;
    *) if [[ $storage != "" ]];then $(command -v mkdir) -p /mnt/unionfs/appbackups/${storage};fi && \
          teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage) && \
       elif [[ $teststorage == $storage ]];then
          backupstorage
       else
         $(which mkdir) -p /mnt/unionfs/appbackups/${storage} && newbackupfolder && backupdocker
       fi ;;
  esac
fi

}

function newbackupfolder() {
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  New Backup folder set to $storage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"
sleep 3

}

function backupdocker() {
storage=${storage}
rundockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -v 'trae' | grep -v 'auth' | grep -v 'cf-companion' | grep -v 'mongo' | grep -v 'dockupdater' | grep -v 'sudobox')
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup running Dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$rundockers

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ all = Backup all running Container ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  read -erp "↪️ Type App-Name to Backup and Press [ENTER]: " typed </dev/tty
  case $typed in
     all|All|ALL) clear && backupall ;;
     Z|z|exit|EXIT|Exit|close) clear && headapps ;;
     *) builddockers=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -x ${typed}) && \
        if [[ $builddockers == $typed ]]; then clear && runbackup ; else backupdocker; fi ;; 
  esac
}

function backupall() {
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
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup is running for $i
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   if [[ ! -d ${DESTINATION} ]];then
      $(which mkdir) -p ${DESTINATION}
   fi
   if [[ ! -d ${DESTINATION}/${STORAGE} ]];then
      $(which mkdir) -p ${DESTINATION}/${STORAGE}
   fi
   forcepush=(tar pigz pv)
   $(which apt) install ${forcepush[@]} -yqq 1>/dev/null 2>&1
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}";do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]];then
      $(which docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Please Wait it can take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
      $(which tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
      $(which docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
   else
      $(which tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   fi
   $(which chown) -hR 1000:1000 ${DESTINATION}/${STORAGE}/${ARCHIVETAR}
done
clear && backupdocker
}

function runbackup() {
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
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Backup is running for ${typed}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
   if [[ ! -d ${DESTINATION} ]];then
      $(which mkdir) -p ${DESTINATION}
   fi
   if [[ ! -d ${DESTINATION}/${STORAGE} ]];then
      $(which mkdir) -p ${DESTINATION}/${STORAGE}
   fi
   forcepush=(tar pigz pv)
   $(which apt) install ${forcepush[@]} -yqq 1>/dev/null 2>&1
   appfolder=/opt/dockserver/apps/
   IGNORE="! -path '**.subactions/**'"
   mapfile -t files < <(eval find ${appfolder} -type f -name $typed.yml ${IGNORE})
   for i in "${files[@]}";do
       section=$(dirname "${i}" | sed "s#${appfolder}##g" | sed 's/\/$//')
   done
   if [[ ${section} == "mediaserver" || ${section} == "mediamanager" ]];then
      $(which docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Please Wait it can take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
      $(which tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
      $(which docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
   else
      $(which tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   fi
   $(which chown) -hR 1000:1000 ${DESTINATION}/${STORAGE}/${ARCHIVETAR}
   clear && backupdocker
else
   clear && backupdocker
fi
}

function restorestorage() {
storage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -v 'sudobox')
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore folder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$storage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -erp "↪️ Type Name to set the Backup-Folder and Press [ENTER]: " storage </dev/tty
  case $typed in
     Z|z|exit|EXIT|Exit|close) clear && headapps ;;
     *) teststorage=$(ls -1p /mnt/unionfs/appbackups/ | grep '/$' | $(command -v sed) 's/\/$//' | grep -x $storage) && \
        if [[ $teststorage == $storage ]];then clear && restorestorage; else backupstorage; fi ;;
  esac
}

function restoredocker() {
storage=${storage}
runrestore=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -v 'trae' | grep -v 'auth' | grep -v 'sudobox')
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore Dockers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$runrestore

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -erp "↪️ Type App-Name to Restore and Press [ENTER]: " typed </dev/tty
  case $typed in
     all|All|ALL) clear && restoreall ;;
     *) builddockers=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -x $typed) && \
        if [[ $builddockers == $typed ]]; then clear && runrestore ; else restoredocker; fi ;;
  esac
}

function restoreall() {
STORAGE=${storage}
FOLDER="/opt/appdata"
DESTINATION="/mnt/unionfs/appbackups"
apps=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -v 'trae' | grep -v 'auth' | grep -v 'sudobox')
forcepush=(tar pigz pv)
$(which apt) install ${forcepush[@]} -yqq 1>/dev/null 2>&1

for app in ${apps};do
   basefolder="/opt/appdata"
   if [[ ! -d $basefolder/$app ]];then
   ARCHIVE=$app
   ARCHIVETAR=${ARCHIVE}.tar.gz
      echo "Create folder for $i is running"  
      folder=$basefolder/$app
      for appset in ${folder};do
          $(which mkdir) -p $appset
          $(which find) $appset -exec $(command -v chmod) a=rx,u+w {} \;
          $(which find) $appset -exec $(command -v chown) -hR 1000:1000 {} \;
      done
   fi
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore is running for $i
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   $(which unpigz) -dcqp 8 ${DESTINATION}/${STORAGE}/${ARCHIVETAR} | $(command -v pv) -pterb | $(command -v tar) pxf - -C ${FOLDER}/${ARCHIVE} --strip-components=1
done
clear && headapps
}

function runrestore() {
typed=${typed}
STORAGE=${storage}
FOLDER="/opt/appdata"
ARCHIVE=${typed}
ARCHIVETAR=${ARCHIVE}.tar.gz
restorebackup=restoredocker
DESTINATION="/mnt/unionfs/appbackups"
basefolder="/opt/appdata"
compose="compose/docker-compose.yml"
forcepush=(tar pigz pv)
$(which apt) install ${forcepush[@]} -yqq 1>/dev/null 2>&1

   folder=$basefolder/${typed}
   for i in ${folder};do
       $(which mkdir) -p $i
       $(which find) $i -exec $(command -v chmod) a=rx,u+w {} \;
       $(which find) $i -exec $(command -v chown) -hR 1000:1000 {} \;
   done

builddockers=$(ls -1p /mnt/unionfs/appbackups/${storage} | $(command -v sed) -e 's/.tar.gz//g' | grep -x $typed)
if [[ $builddockers == $typed ]];then
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore is running for ${typed}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   $(which unpigz) -dcqp 8 ${DESTINATION}/${STORAGE}/${ARCHIVETAR} | $(command -v pv) -pterb | $(command -v tar) pxf - -C ${FOLDER}/${ARCHIVE} --strip-components=1
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

function runinstall() {
  restorebackup=${restorebackup:-null}
  section=${section}
  typed=${typed}
  updatecompose
  compose="compose/docker-compose.yml"
  composeoverwrite="compose/docker-compose.override.yml"
  storage="/mnt/downloads"
  appfolder="/opt/dockserver/apps"
  basefolder="/opt/appdata"
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Please Wait, We are installing ${typed} for you
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  $(which mkdir) -p $basefolder/compose/
  $(which find) $basefolder/compose/ -type f -name "docker*" -exec rm -f {} \;
  $(which rsync) $appfolder/${section}/${typed}.yml $basefolder/$compose -aqhv
  if [[ ${section} == "mediaserver" || ${section} == "encoder" ]]; then
     if [[ -x "/dev/dri" ]]; then
        if test -f "/etc/modprobe.d/blacklist-hetzner.conf"; then
           $(which rsync) $appfolder/${section}/.gpu/INTEL.yml $basefolder/$composeoverwrite -aqhv
        elif $(which nvidia-smi --version) ]]; then
           $(which rsync) $appfolder/${section}/.gpu/NVIDIA.yml $basefolder/$composeoverwrite -aqhv
        else
           echo "You are using an unsupported graphic system."
        fi
     fi
     if [[ -f $basefolder/$composeoverwrite ]];then
        if [[ $(uname) == "Darwin" ]];then
           $(which sed) -i '' "s/<APP>/${typed}/g" $basefolder/$composeoverwrite
        else
           $(which sed) -i "s/<APP>/${typed}/g" $basefolder/$composeoverwrite
        fi
     fi
  fi
  if [[ -f $appfolder/${section}/.overwrite/${typed}.overwrite.yml ]];then
     $(command -v rsync) $appfolder/${section}/.overwrite/${typed}.overwrite.yml $basefolder/$composeoverwrite -aqhv
  fi
  if [[ ! -d $basefolder/${typed} ]];then
     folder=$basefolder/${typed}
     for fol in ${folder};do
         $(which mkdir) -p $fol
         $(which find) $fol -exec $(which chmod) a=rx,u+w {} \;
         $(which find) $fol -exec $(which chown) -hR 1000:1000 {} \;
     done
  fi
  container=$($(which docker) ps -aq --format '{{.Names}}' | grep -x ${typed})
  if [[ $container == ${typed} ]];then
     docker="stop rm"
     for con in ${docker};do
         $(which docker) $con ${typed} 1>/dev/null 2>&1
     done
     $(which docker) image prune -af 1>/dev/null 2>&1
  else
     $(which docker) image prune -af 1>/dev/null 2>&1
  fi
  if [[ ${typed} == "vnstat" ]];then vnstatcheck;fi
  if [[ ${typed} == "autoscan" ]];then autoscancheck;fi
  if [[ ${typed} == "plex" ]];then plexclaim && plex443;fi
  if [[ ${typed} == "jdownloader2" ]];then
     folder=$storage/${typed}
     for jdl in ${folder};do
         $(which mkdir) -p $jdl
         $(which find) $jdl -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $jdl -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "rutorrent" ]];then
     folder=$storage/torrent
     for rto in ${folder};do
         $(which mkdir) -p $rto/{temp,complete}/{movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux}
         $(which find) $rto -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $rto -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "lidarr" ]];then
     folder=$storage/amd
     for lid in ${folder};do
         $(which mkdir) -p $lid
         $(which find) $lid -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $lid -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ && ${typed} == "readarr" ]];then
     folder=$storage/books
     for rea in ${folder};do
         $(which mkdir) -p $rea
         $(which find) $rea -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $rea -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "mount" ]];then
     $(which docker) stop mount &>/dev/null && $(command -v docker) rm mount &>/dev/null
     folderunmount
  fi
  if [[ ${typed} == "youtubedl-material" ]];then
     folder="appdata audio video subscriptions"
     for ytf in ${folder};do
         $(which mkdir) -p $basefolder/${typed}/$ytf
         $(which find) $basefolder/${typed}/$ytf -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $basefolder/${typed}/$ytf -exec $(command -v chown) -hR 1000:1000 {} \;
     done
     folder=$storage/youtubedl
     for ytdl in ${folder};do
         $(which mkdir) -p $ytdl
         $(which find) $ytdl -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $ytdl -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "handbrake" ]];then
     folder=$storage/${typed}
     for hbrake in ${folder};do
         $(which mkdir) -p $hbrake/{watch,storage,output}
         $(which find) $hbrake -exec $(command -v chmod) a=rx,u+w {} \;
         $(which find) $hbrake -exec $(command -v chown) -hR 1000:1000 {} \;
     done
  fi
  if [[ ${typed} == "bitwarden" ]];then
     if [[ -f $appfolder/.subactions/${typed}.sh ]];then $(which bash) $appfolder/.subactions/${typed}.sh;fi
  fi
  if [[ ${typed} == "dashy" ]];then
     if [[ -f $appfolder/.subactions/${typed}.sh ]];then $(which bash) $appfolder/.subactions/${typed}.sh;fi
  fi
  if [[ ${typed} == "invitarr" ]];then
      $(which nano) $basefolder/$compose      
      $(which rsync) $appfolder/.subactions/${typed}.js $basefolder/${typed}/config.ini -aqhv
      $(which nano) $basefolder/${typed}/config.ini
  fi
  if [[ ${typed} == "plex-utills" ]];then
     if [[ -f $appfolder/.subactions/${typed}.sh ]];then $(command -v bash) $appfolder/.subactions/${typed}.sh;fi
  fi
  if [[ ${typed} == "petio" ]];then $(command -v mkdir) -p $basefolder/${typed}/{db,config,logs} && $(which chown) -hR 1000:1000 $basefolder/${typed}/{db,config,logs} 1>/dev/null 2>&1;fi
  if [[ ${typed} == "tdarr" ]];then $(command -v mkdir) -p $basefolder/${typed}/{server,configs,logs,encoders} && $(which chown) -hR 1000:1000 $basefolder/${typed}/{server,configs,logs} 1>/dev/null 2>&1;fi
  if [[ -f $basefolder/$compose ]];then
     $(which cd) $basefolder/compose/
     $(which docker-compose) config 1>/dev/null 2>&1
     errorcode=$?
     if [[ $errorcode -ne 0 ]];then
     erroline=$($(which docker-compose) config)
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR
    Compose check of ${typed} has failed
    Return code is ${errorcode}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
sleep 5
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ OUTPUT OF COMPOSER ERROR
    ${erroline}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
  clear && interface
     else
        $(which docker-compose) up -d --force-recreate 1>/dev/null 2>&1
     fi
  fi
  if [[ ${section} == "mediaserver" || ${section} == "request" ]];then subtasks;fi
  if [[ ${typed} == "xteve" || ${typed} == "heimdall" || ${typed} == "librespeed" || ${typed} == "tautulli" || ${typed} == "nextcloud" ]];then subtasks;fi
  if [[ ${section} == "downloadclients" ]];then subtasks;fi
  if [[ ${typed} == "overseerr" ]];then overserrf2ban;fi
     setpermission
     $($(which docker) ps -aq --format '{{.Names}}{{.State}}' | grep -qE ${typed}running 1>/dev/null 2>&1)
     errorcode=$?
  if [[ $errorcode -eq 0 ]];then
     TRAEFIK=$(cat $basefolder/$compose | grep "traefik.enable" | wc -l)
  if [[ ${TRAEFIK} == "0" ]];then
  printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} has successfully deployed and is now working     
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
else
  source $basefolder/compose/.env
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} has successfully deployed = > https://${typed}.${DOMAIN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  sleep 10
  clear
  fi
  fi
  if [[ ${restorebackup} == "restoredocker" ]];then clear && restorestorage;fi
  clear
}

function setpermission() {
approot=$($(which ls) -l $basefolder/${typed} | awk '{if($3=="root") print $0}' | wc -l)
if [[ $approot -gt 0 ]];then
IFS=$'\n'
mapfile -t setownapp < <(eval $(command -v ls) -l $basefolder/${typed}/ | awk '{if($3=="root") print $0}' | awk '{print $9}')
  for appset in ${setownapp[@]};do
      if [[ $(whoami) == "root" ]];then $(which chown) -hR 1000:1000 $basefolder/${typed}/$appset;fi
      if [[ $(whoami) != "root" ]];then $(which chown) -hR $(whoami):$(whoami) $basefolder/${typed}/$appset;fi
  done
fi
dlroot=$($(which ls) -l $storage/ | awk '{if($3=="root") print $0}' | wc -l)
if [[ $dlroot -gt 0 ]];then
IFS=$'\n'
mapfile -t setowndl < <(eval $(command -v ls) -l $storage/ | awk '{if($3=="root") print $0}' | awk '{print $9}')
  for dlset in ${setowndl[@]};do
      if [[ $(whoami) == "root" ]];then $(command -v chown) -hR 1000:1000 $storage/$dlset;fi
      if [[ $(whoami) != "root" ]];then $(command -v chown) -hR $(whoami):$(whoami) $storage/$dlset;fi
  done
fi
}

function overserrf2ban() {
OV2BAN="/etc/fail2ban/filter.d/overseerr.local"
if [[ ! -f $OV2BAN ]];then
   cat > $OV2BAN << EOF; $(echo)
## overseerr fail2ban filter ##
[Definition]
failregex = .*\[info\]\[Auth\]\: Failed sign-in attempt.*"ip":"<HOST>"
EOF
fi

f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
if [[ $f2ban != "false" ]];then $(which systemctl) reload-or-restart fail2ban.service 1>/dev/null 2>&1;fi
}

function vnstatcheck() {
if [[ ! -x $(command -v vnstat) ]];then $(which apt) install vnstat -yqq;fi
}

function autoscancheck() {
$(docker ps -aq --format={{.Names}} | grep -E 'arr|ple|emb|jelly' 1>/dev/null 2>&1)
code=$?
if [[ $code -eq 0 ]];then
   $(command -v rsync) $appfolder/.subactions/${typed}.config.yml $basefolder/${typed}/config.yml -aqhv
   $(command -v bash) $appfolder/.subactions/${typed}.sh
fi
}

function plexclaim() {
compose="compose/docker-compose.yml"
basefolder="/opt/appdata"
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  PLEX CLAIM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Please claim your Plex server
    https://www.plex.tv/claim/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
  read -erp "Enter your PLEX CLAIM CODE : " PLEXCLAIM </dev/tty
  if [[ $PLEXCLAIM != "" ]];then
     if [[ $(uname) == "Darwin" ]];then
        $(which sed) -i '' "s/PLEX_CLAIM_ID/$PLEXCLAIM/g" $basefolder/$compose
     else
        $(which sed) -i "s/PLEX_CLAIM_ID/$PLEXCLAIM/g" $basefolder/$compose
     fi
  else
     echo "Plex Claim cannot be empty"
     plexclaim
  fi
}

function plex443() {
basefolder="/opt/appdata"
source $basefolder/compose/.env
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty

}

function subtasks() {
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
        if [[ -f $appfolder/.subactions/${typed}.sh ]];then $(which bash) $appfolder/.subactions/${typed}.sh;fi
     fi
  if [[ $authadd == "" ]];then
     if [[ ${section} == "mediaserver" || ${section} == "request" ]];then
     { head -n 55 $conf;
     echo "\
    - domain: ${typed}.${DOMAIN}
      policy: bypass"; tail -n +56 $conf; } > $confnew
        if [[ -f $conf ]];then $(which rsync) $conf $confbackup -aqhv;fi
        if [[ -f $conf ]];then $(which rsync) $confnew $conf -aqhv;fi
        if [[ $authcheck == "true" ]];then $(which docker) restart authelia 1>/dev/null 2>&1;fi
        if [[ -f $conf ]];then $(command -v rm) -rf $confnew;fi
     fi
     if [[ ${typed} == "xteve" || ${typed} == "heimdall" || ${typed} == "librespeed" || ${typed} == "tautulli" || ${typed} == "nextcloud" ]];then
     { head -n 55 $conf;
     echo "\
    - domain: ${typed}.${DOMAIN}
      policy: bypass"; tail -n +56 $conf; } > $confnew
        if [[ -f $conf ]];then $(which rsync) $conf $confbackup -aqhv;fi
        if [[ -f $conf ]];then $(which rsync) $confnew $conf -aqhv;fi
        if [[ $authcheck == "true" ]];then $(which docker) restart authelia 1>/dev/null 2>&1;fi
        if [[ -f $conf ]];then $(which rm) -rf $confnew;fi
     fi
  fi
  if [[ ${section} == "mediaserver" || ${section} == "request" || ${section} == "downloadclients" ]];then $(which docker) restart ${typed} 1>/dev/null 2>&1;fi
  if [[ ${section} == "request" ]];then $(which chown) -R 1000:1000 $basefolder/${typed} 1>/dev/null 2>&1;fi
}

function removeapp() {
list=$($(which docker) ps -aq --format '{{.Names}}' | grep -vE 'auth|trae|cf-companion')
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀   App Removal Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$list

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -erp "↪️ Type App-Name to remove and Press [ENTER]: " typed </dev/tty
  case $typed in
     Z|z|exit|EXIT|Exit|close) clear && headapps ;;
     *) checktyped=$($(which docker) ps -aq --format={{.Names}} | grep -x $typed)
        if [[ $checktyped == $typed ]];then clear && deleteapp; else removeapp; fi ;;
  esac
}

function deleteapp() {
  typed=${typed}
  basefolder="/opt/appdata"
  storage="/mnt/downloads"
  source $basefolder/compose/.env
  conf=$basefolder/authelia/configuration.yml
  checktyped=$($(command -v docker) ps -aq --format={{.Names}} | grep -x $typed)
  auth=$(cat -An $conf | grep -x ${typed}.${DOMAIN} | awk '{print $1}')
  if [[ $checktyped == $typed ]];then
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} removal started    
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
     app=${typed}
     for i in ${app};do
         $(which docker) stop $i 1>/dev/null 2>&1
         $(which docker) rm $i 1>/dev/null 2>&1
         $(which docker) image prune -af 1>/dev/null 2>&1
     done
     if [[ -d $basefolder/${typed} ]];then 
        folder=$basefolder/${typed}
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   App ${typed} folder removal started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
        for i in ${folder};do
            $(which rm) -rf $i 1>/dev/null 2>&1
        done
     fi
     if [[ -d $storage/${typed} ]];then 
        folder=$storage/${typed}
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Storage ${typed} folder removal started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
        for i in ${folder};do
            $(which rm) -rf $i 1>/dev/null 2>&1
        done
     fi
     if [[ $auth == ${typed} ]];then
        if [[ ! -x $(command -v bc) ]];then $(command -v apt) install bc -yqq 1>/dev/null 2>&1;fi
           source $basefolder/compose/.env
           authrmapp=$(cat -An $conf | grep -x ${typed}.${DOMAIN})
           authrmapp2=$(echo "$(${authrmapp} + 1)" | bc)
        if [[ $authrmapp != "" ]];then sed -i '${authrmapp};${authrmapp2}d' $conf;fi
           $($(which docker) ps -aq --format '{{.Names}}' | grep -x authelia 1>/dev/null 2>&1)
           newcode=$?
        if [[ $newcode -eq 0 ]];then $(which docker) restart authelia;fi
     fi
     source $basefolder/compose/.env 
     if [ ${DOMAIN1_ZONE_ID} != "" ] && [ ${DOMAIN} != "" ] && [ ${CLOUDFLARE_EMAIL} != "" ] ; then
        $(which apt) install curl -yqq
        dnsrecordid=$(curl -sX GET "https://api.cloudflare.com/client/v4/zones/$DOMAIN1_ZONE_ID/dns_records?name=${typed}.${DOMAIN}" -H "X-Auth-Email: $CLOUDFLARE_EMAIL" -H "X-Auth-Key: $CLOUDFLARE_API_KEY" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
        if [[ $dnsrecordid != "" ]] ; then
           result=$(curl -sX DELETE "https://api.cloudflare.com/client/v4/zones/$DOMAIN1_ZONE_ID/dns_records/$dnsrecordid" -H "X-Auth-Email: $CLOUDFLARE_EMAIL" -H "X-Auth-Key: $CLOUDFLARE_API_KEY" -H "Content-Type: application/json")
           if [[ $result != "" ]]; then
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} CNAME record removed from Cloudflare 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
           fi
        fi
    fi
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ${typed} removal finished
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
    sleep 2 && removeapp
  else
     removeapp
  fi
}

function updatecompose() {
    $(which curl) -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
    $(which ln) -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    $(which chmod) +x /usr/local/bin/docker-compose /usr/bin/docker-compose
}

function color() {

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
normal=$(tput sgr0)

}
# ENDSTAGE
