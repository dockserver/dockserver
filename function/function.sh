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

### DOCKER CREATE + CONFIG LOGIC || FUNCTION
function runcreate() {
$(which docker) pull -q docker.dockserver.io/dockserver/docker-create

TYPE=$1
PART=$2

if [[ ! "$(grep '1000' /etc/passwd | cut -d: -f1 | awk '{print $1}')" ]];then
   USER=1000
   USERID=1000
else
   USER=$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')
   USERID=$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $2}')
fi

$(which docker) run -d \
 --name=dockserver-create \
 -e PUID=$USER \
 -e PGID=$USERID \
 -e TZ=Europe/London \
 -v /opt:/opt:rw \
 -v /mnt:/mnt:rw \
 docker.dockserver.io/dockserver/docker-create $TYPE $PART
}

function killruncreate() {
  $(which docker) stop dockserver-create
  $(which docker) rm dockserver-create
}  

function runconfig() {
$(which docker) pull -q docker.dockserver.io/dockserver/docker-config

TYPE=$1
PART=$2
if [[ ! "$(grep '1000' /etc/passwd | cut -d: -f1 | awk '{print $1}')" ]];then
   USER=1000
   USERID=1000
else
   USER=$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')
   USERID=$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $2}')
fi

$(which docker) run -d \
 --name=dockserver-config \
 -e PUID=$USER \
 -e PGID=$USERID \
 -e TZ=Europe/London \
 -v /opt:/opt:rw \
 docker.dockserver.io/dockserver/docker-config $TYPE $PART
}

function killrunconfig() {
  $(which docker) stop dockserver-config
  $(which docker) rm dockserver-config
}

### DOCKER CREATE + CONFIG LOGIC || FUNCTION
#####################################

### GLOBAL CONFIG

function preinstall() {
# shellcheck disable=SC2046
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install Runs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
     case $(. /etc/os-release && echo "$ID") in
        ubuntu|debian|raspian) \
           type="ubuntu" \
           aptcommand="apt" \
           aptupdate="update" \
           aptupgrade="upgrade" ;; 
        *) type='' && exit 0 ;
     esac

     basefolder="/opt/appdata"

     proxydel      

     case $(. /etc/os-release && echo "$ID") in
        ubuntu|debian|raspian) fastapt ;;
     esac

     runcreate
     $(which chown) -R 1000:1000 /opt/dockserver
 
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
    runcreate
    $(which chmod) a=rx,u+w /opt/lxc/.lxcstart.sh
    $(which bash) /opt/lxc/.lxcstart.sh
    $(which crontab) -l > cron_bkp
    $(which echo) "@reboot root /bin/bash /opt/lxc/.lxcstart.sh 1>/dev/null 2>&1" >> cron_bkp
    $(which crontab) cron_bkp
    $(which rm) cron_bkp
    killruncreate
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

function igpuhetzner() {
   runcreate
   $(which bash) /opt/hetzner/hetzner.sh
   killruncreate
}

function nvidiagpu() {
   runcreate
   $(which bash) /opt/nvidia/nvidia.sh
   killruncreate
}

function run() {
if [ ! $(which docker) ] && [ ! $(which docker-compose) ] && [ ! $(docker --version) ]; then
   preinstall
fi

if [[ -d ${dockserver} ]];then
   envmigra && cleanup && clear && appstartup
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

    $(which docker) stop $rec &>/dev/null
    $(which docker) network disconnect proxy $rec &>/dev/null
    $(which docker) network connect proxy $rec &>/dev/null
    $(which docker) start $rec &>/dev/null

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
    case $(. /etc/os-release && echo "$ID") in
        ubuntu|debian|raspian) \
        if ! type aria2c >/dev/null 2>&1; then
           $(which apt) update -yqq && \
           $(which apt) install --force-yes -yqq aria2
        fi && \
        if ! test -f "/etc/apt-fast.conf"; then
           $(which bash) -c "$(curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"
           echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
           echo debconf apt-fast/dlflag boolean true | debconf-set-selections
          echo debconf apt-fast/aptmanager string apt | debconf-set-selections
        fi
    esac
}

function appstartup() {
     dockertraefik=$($(which docker) ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -E 'traefik')
     ntdocker=$($(which docker)docker network ls | grep -E 'proxy')
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

   envcreate && certs && secrets
   timezone && cleanup
   jounanctlpatch && serverip
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

function install() {
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
   $(which docker) stop ${typed} 1>/dev/null 2>&1 && echo "We stopped now $typed"
printf "%1s\n" "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Please Wait it can take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
   $(which tar) ${OPTIONSTAR} -C ${FOLDER}/${ARCHIVE} -pcf ${DESTINATION}/${STORAGE}/${ARCHIVETAR} ./
   $(which docker) start ${typed} 1>/dev/null 2>&1  && echo "We started now $typed"
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
      echo "Create folder for $app is running"  
      folder=$basefolder/$app
      for appset in ${folder};do
          $(which mkdir) -p $appset
          $(which find) $appset -exec $(command -v chmod) a=rx,u+w {} \;
          $(which find) $appset -exec $(command -v chown) -hR 1000:1000 {} \;
      done
   fi
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀  Restore is running for $app
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
   $(which unpigz) -dcqp 8 ${DESTINATION}/${STORAGE}/${ARCHIVETAR} | $(command -v pv) -pterb | $(command -v tar) pxf - -C ${FOLDER}/${ARCHIVE} --strip-components=1
   $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/$app/docker-compose.yml up -d --force-recreate 1>/dev/null 2>&1

done
clear && headapps
}

function runrestore() {
typed=${typed}
STORAGE=${storage}
FOLDER="/opt/appdata"
ARCHIVE=${typed}
ARCHIVETAR=${ARCHIVE}.tar.gz
DESTINATION="/mnt/unionfs/appbackups"
basefolder="/opt/appdata"
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
   $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml up -d --force-recreate 1>/dev/null 2>&1
else
   clear && restoredocker
fi
}

function runinstall() {
  restorebackup=${restorebackup:-null}
  typed=${typed}
  updatecompose
  storage="/mnt/downloads"
  appfolder="/opt/dockserver/apps"
  basefolder="/opt/appdata"
  composeoverwrite="$basefolder/compose/docker-compose.override.yml"

printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Please Wait, We are installing ${typed} for you
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"

  if [[ ${section} == "mediaserver" || ${section} == "encoder" ]]; then
     if [[ -x "/dev/dri" ]]; then
        if test -f "/etc/modprobe.d/blacklist-hetzner.conf"; then
           $(which rsync) $appfolder/.gpu/INTEL.yml $basefolder/$composeoverwrite -aqhv
        elif $(which nvidia-smi --version) ]]; then
           $(which rsync) $appfolder/.gpu/NVIDIA.yml $basefolder/$composeoverwrite -aqhv
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
  $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml stop 1>/dev/null 2>&1
  $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml rm 1>/dev/null 2>&1
  $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml config 1>/dev/null 2>&1
    errorcode=$?
  if [[ $errorcode -ne 0 ]];then
     erroline=$($(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml config)

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
      $(which docker-compose) --env-file $basefolder/compose/.env -f $appfolder/${typed}/docker-compose.yml up -d --force-recreate 1>/dev/null 2>&1
   fi

     $($(which docker) ps -aq --format '{{.Names}}{{.State}}' | grep -qE ${typed}running 1>/dev/null 2>&1)
     errorcode=$?
  if [[ $errorcode -eq 0 ]];then
     TRAEFIK=$(cat $appfolder/${typed}/docker-compose.yml | grep "traefik.enable" | wc -l)
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
