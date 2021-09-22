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
updatesystem() {
if [[ $EUID -ne 0 ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit 0
fi
while true; do
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install Runs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  basefolder="/opt/appdata"
  source="/opt/dockserver/preinstall/templates/local"
  oldsinstall && proxydel
  package_list="update upgrade dist-upgrade autoremove autoclean"
  for i in ${package_list}; do
      echo "running now $i" && $(command -v apt) $i -yqq 1>/dev/null 2>&1
  done
  folder="/mnt"
  for fo in ${folder}; do
      $(command -v mkdir) -p $fo/{unionfs,downloads,incomplete,torrent,nzb} \
             $fo/{incomplete,downloads}/{nzb,torrent}/{complete,temp,movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux} \
             $fo/downloads/torrent/{temp,complete}/{movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux} \
             $fo/{torrent,nzb}/watch
      $(command -v find) $fo -exec $(command -v chmod) a=rx,u+w {} \;
      $(command -v find) $fo -exec $(command -v chown) -hR 1000:1000 {} \;
  done
  appfolder="/opt/appdata"
  for app in ${appfolder}; do
      $(command -v mkdir) -p $app/{compose,system}
      $(command -v find) $app -exec $(command -v chmod) a=rx,u+w {} \;
      $(command -v find) $app -exec $(command -v chown) -hR 1000:1000 {} \;
  done
  config="/etc/sysctl.d/99-sysctl.conf"
  ipv6=$(cat $config | grep -qE 'ipv6' && echo true || false)
  if [[ -f $config ]];then
     if [ $ipv6 != 'true' ] || [ $ipv6 == 'true' ];then
       grep -qE 'net.ipv6.conf.all.disable_ipv6 = 1' $config || \
            echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> $config
       grep -qE 'net.ipv6.conf.default.disable_ipv6 = 1' $config || \
            echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> $config
       grep -qE 'net.ipv6.conf.lo.disable_ipv6 = 1' $config || \
            echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> $config
       grep -qE 'net.core.default_qdisc=fq' $config || \
            echo 'net.core.default_qdisc=fq' >> $config
       grep -qE 'net.ipv4.tcp_congestion_control=bbr' $config || \
            echo 'net.ipv4.tcp_congestion_control=bbr' >> $config            
       sysctl -p -q
     fi
  fi
  if [[ ! -x $(command -v docker) ]];then
     if [[ -r /etc/os-release ]];then lsb_dist="$(. /etc/os-release && echo "$ID")"; fi
        package_listubuntu="apt-transport-https ca-certificates gnupg-agent"
        package_listdebian="apt-transport-https ca-certificates gnupg-agent gnupg2"
        package_basic="software-properties-common language-pack-en-base pciutils lshw nano rsync fuse curl wget tar pigz pv"
        if [[ $lsb_dist == 'ubuntu' ]] || [[ $lsb_dist == 'rasbian' ]];then
           for i in ${package_listubuntu};do
               echo "Now installing $i" && $(command -v apt) install $i --reinstall -yqq 1>/dev/null 2>&1 && sleep 1
           done
        else
           for i in ${package_listdebian};do
               echo "Now installing $i" && $(command -v apt) install $i --reinstall -yqq 1>/dev/null 2>&1 && sleep 1
           done
        fi
        for i in ${package_basic};do
            echo "Now installing $i" && $(command -v apt) install $i --reinstall -yqq 1>/dev/null 2>&1 && sleep 1
        done
  fi
     $(command -v curl) --silent -fsSL https://raw.githubusercontent.com/docker/docker-install/master/install.sh | sudo bash > /dev/null 2>&1
     $(command -v rsync) -aqhv ${source}/daemon.j2 /etc/docker/daemon.json 1>/dev/null 2>&1
     dockergroup=$(grep -qE docker /etc/group && echo true || echo false)
  if [[ $dockergroup == "false" ]];then $(command -v usermod) -aG docker $(whoami);fi
     dockertest=$($(command -v systemctl) is-active docker | grep -qE 'active' && echo true || echo false)
  if [[ $dockertest != "false" ]];then $(command -v systemctl) reload-or-restart docker.service 1>/dev/null 2>&1 && $(command -v systemctl) enable docker.service >/dev/null 2>&1;fi
     mntcheck=$($(command -v docker) volume ls | grep -qE 'unionfs' && echo true || echo false)
  if [[ $mntcheck == "false" ]];then
     $(command -v curl) --silent -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash 1>/dev/null 2>&1
     $(command -v docker) volume create -d local-persist -o mountpoint=/mnt --name=unionfs
  fi
     networkcheck=$($(command -v docker) network ls | grep -qE 'proxy' && echo true || echo false)
  if [[ $networkcheck == "false" ]];then $(command -v docker) network create --driver=bridge proxy 1>/dev/null 2>&1;fi
  if [[ ! -x $(command -v rsync) ]];then $(command -v apt) install --reinstall rsync -yqq 1>/dev/null 2>&1;fi
  if [ ! -x $(command -v docker-compose) ] || [ -x $(command -v docker-compose) ];then
     COMPOSE_VERSION=$($(command -v curl) --silent -fsSL https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
     sh -c "curl --silent -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
     sh -c "curl --silent -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
     if [[ ! -L "/usr/bin/docker-compose" ]];then $(command -v rm) -f /usr/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose;fi
     $(command -v chmod) a=rx,u+w /usr/local/bin/docker-compose >/dev/null 2>&1
     $(command -v chmod) a=rx,u+w /usr/bin/docker-compose >/dev/null 2>&1
  fi
     dailyapt=$($(command -v systemctl) is-active apt-daily | grep -qE 'active' && echo true || echo false)
     dailyupg=$($(command -v systemctl) is-active apt-daily-upgrade | grep -qE 'active' && echo true || echo false)
  if [[ $dailyapt == "true" || $dailyupg == "true" ]];then
     disable="apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service"
     for i in ${disable};do
        systemctl disable $i >/dev/null 2>&1
     done
  fi
  if [[ -x $(command -v lshw) ]];then
     gpu="ntel NVIDIA"
     for i in ${gpu};do
         TDV=$(lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E $i 1>/dev/null 2>&1 && echo true || echo false)
         if [[ $TDV == "true" ]];then $(command -v bash) ${source}/gpu.sh;fi
     done
  fi
  if [[ ! -x $(command -v ansible) ]];then
     if [[ -r /etc/os-release ]];then lsb_dist="$(. /etc/os-release && echo "$ID")";fi
        package_list="ansible dialog python3-lxml"
        package_listdebian="apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367"
        package_listubuntu="apt-add-repository --yes --update ppa:ansible/ansible"
        if [[ $lsb_dist == 'ubuntu' ]] || [[ $lsb_dist == 'rasbian' ]];then ${package_listubuntu} 1>/dev/null 2>&1;else ${package_listdebian} 1>/dev/null 2>&1;fi
        for i in ${package_list};do
            $(command -v apt) install $i --reinstall -yqq 1>/dev/null 2>&1
        done
     if [[ $lsb_dist == 'ubuntu' ]];then add-apt-repository --yes --remove ppa:ansible/ansible;fi
  fi
     invet="/etc/ansible/inventories"
     conf="/etc/ansible/ansible.cfg"
     loc="local"
     if [[ ! -d $invet ]];then $(command -v mkdir) -p $invet 1>/dev/null 2>&1;fi
        if [[ ! -f $invet/$loc ]];then
        echo "\
[local]
127.0.0.1 ansible_connection=local" > $invet/$loc
        fi
     grep -qE "inventory      = /etc/ansible/inventories/local" $conf || \
          echo "inventory      = /etc/ansible/inventories/local" >> $conf
  if [[ "$(systemd-detect-virt)" == "lxc" ]];then $(command -v bash) /opt/dockserver/preinstall/installer/subinstall/lxc.sh;fi
  if [[ ! -x $(command -v fail2ban-client) ]];then $(command -v apt) install fail2ban -yqq 1>/dev/null 2>&1; fi
     while true; do
         f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
         if [[ $f2ban != 'true' ]];then echo "Waiting for fail2ban to start" && sleep 1 && continue;else break;fi
     done
     ORGFILE="/etc/fail2ban/jail.conf"
     LOCALMOD="/etc/fail2ban/jail.local"
  if [[ ! -f $LOCALMOD ]];then $(command -v rsync) -aqhv $ORGFILE $LOCALMOD;fi
     MOD=$(cat $LOCALMOD | grep -qE '\[authelia\]' && echo true || echo false)
  if [[ $MOD == "false" ]];then
     echo "\
[authelia]
enabled = true
port = http,https,9091
filter = authelia
logpath = /opt/appdata/authelia/authelia.log
maxretry = 2
bantime = 90d
findtime = 7d
chain = DOCKER-USER">> /etc/fail2ban/jail.local
  sed -i "s#/var/log/traefik/access.log#/opt/appdata/traefik/traefik.log#g" /etc/fail2ban/jail.local
  sed -i "s#rotate 4#rotate 1#g" /etc/logrotate.conf
  sed -i "s#weekly#daily#g" /etc/logrotate.conf
  fi
  f2ban=$($(command -v systemctl) is-active fail2ban | grep -qE 'active' && echo true || echo false)
  if [[ $f2ban != "false" ]];then
     $(command -v systemctl) reload-or-restart fail2ban.service 1>/dev/null 2>&1
     $(command -v systemctl) enable fail2ban.service 1>/dev/null 2>&1
  fi
  update-locale LANG=LANG=LC_ALL=en_US.UTF-8 LANGUAGE 1>/dev/null 2>&1
  localectl set-locale LANG=LC_ALL=en_US.UTF-8 1>/dev/null 2>&1
  ## raiselimits
  sed -i '/hard nofile/ d' /etc/security/limits.conf
  sed -i '/soft nofile/ d' /etc/security/limits.conf
  sed -i '$ i\* hard nofile 32768\n* soft nofile 16384' /etc/security/limits.conf
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  break
done
}
proxydel() {
delproxy="apache2 nginx"
for i in ${delproxy};do
    $(command -v systemctl) stop $i 1>/dev/null 2>&1
    $(command -v systemctl) disable $i 1>/dev/null 2>&1
    $(command -v apt) remove $i -yqq 1>/dev/null 2>&1
    $(command -v apt) purge $i -yqq 1>/dev/null 2>&1
  break
done
}
oldsinstall() {
  oldsolutions="plexguide cloudbox gooby sudobox sbox"
  for i in ${oldsolutions};do
      folders="/var/ /opt/ /home/ /srv/"
      for ii in ${folders};do
          show=$(find $ii -maxdepth 2 -type d -name $i -print)
          if [[ $show != '' ]];then
             echo ""
             printf "\033[0;31m You need to reinstall your operating system.
sorry, you need a freshly installed server. We can not install on top of $i\033[0m\n"
             echo ""
             read -erp "Type confirm when you have read the message: " input
             if [[ "$input" = "confirm" ]];then exit ;else oldsinstall;fi
          fi
      done
  done
}
# FUNCTIONS END ##############################################################
updatesystem
#EOF
