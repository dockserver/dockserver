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
   while true; do
      # shellcheck disable=SC2046
      printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install Runs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
      basefolder="/opt/appdata"
      source="/opt/dockserver/preinstall/templates/local"
      oldsinstall && proxydel
      package_list="update upgrade dist-upgrade autoremove autoclean"
      for i in ${package_list}; do
         echo "running now $i" && apt $i -yqq 1>/dev/null 2>&1
      done
      folder="/mnt"
      for fo in ${folder}; do
         mkdir -p $fo/{unionfs,downloads,incomplete,torrent,nzb} \
         $fo/{incomplete,downloads}/{nzb,torrent}/{complete,temp,movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux} \
         $fo/downloads/torrent/{temp,complete}/{movies,tv,tv4k,movies4k,movieshdr,tvhdr,remux} \
         $fo/{torrent,nzb}/watch
         find $fo -exec $(command -v chmod) a=rx,u+w {} \;
         find $fo -exec $(command -v chown) -hR 1000:1000 {} \;
      done
      appfolder="/opt/appdata"
      for app in ${appfolder}; do
        mkdir -p $app/{compose,system}
        find $app -exec $(command -v chmod) a=rx,u+w {} \;
        find $app -exec $(command -v chown) -hR 1000:1000 {} \;
      done

      #### CHANGE DNS SERVERS ####
      mapfile -t "FILE" < <($(which find) "/etc/netplan" -type f -name "*.yaml")
      for NETYAML in "${FILE[@]}"; do
         $(which sed) -i 's/185.12.64.1/9.9.9.9/' ${NETYAML} &>/dev/null
         $(which sed) -i 's/185.12.64.2/149.112.112.112/' ${NETYAML} &>/dev/null
         $(which sed) -i 's/2a01:4ff:ff00::add:2/2620:fe::fe/' ${NETYAML} &>/dev/null
         $(which sed) -i 's/2a01:4ff:ff00::add:1/2620:fe::9/' ${NETYAML} &>/dev/null
      done
      netplan apply

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

      bash -c "$(curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"
      echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
      echo debconf apt-fast/dlflag boolean true | debconf-set-selections
      echo debconf apt-fast/aptmanager string apt | debconf-set-selections

      package_basic=(software-properties-common rsync language-pack-en-base pciutils lshw nano rsync fuse curl wget tar pigz pv iptables ipset fail2ban)
      apt install ${package_basic[@]} --reinstall -yqq 1>/dev/null 2>&1 && sleep 1

      if [ -z `command -v docker` ]; then
         curl --silent -fsSL https://raw.githubusercontent.com/docker/docker-install/master/install.sh | sudo bash >/dev/null 2>&1
      fi
         rsync -aqhv ${source}/daemon.j2 /etc/docker/daemon.json 1>/dev/null 2>&1
         usermod -aG docker $(whoami)
         systemctl reload-or-restart docker.service 1>/dev/null 2>&1
         systemctl enable docker.service >/dev/null 2>&1
         curl --silent -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash 1>/dev/null 2>&1
         docker volume create -d local-persist -o mountpoint=/mnt --name=unionfs
         docker network create --driver=bridge proxy 1>/dev/null 2>&1
      if [ -z `command -v docker-compose` ]; then
         curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
         ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
         chmod +x /usr/local/bin/docker-compose /usr/bin/docker-compose
      fi

      disable=(apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service)
      systemctl disable ${disable[@]} >/dev/null 2>&1
       
      gpu="ntel NVIDIA"
      for i in ${gpu}; do
            TDV=$(lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E $i 1>/dev/null 2>&1 && echo true || echo false)
            if [[ $TDV == "true" ]]; then $(command -v bash) ${source}/gpu.sh; fi
      done

      if [ -z `command -v ansible` ]; then
         if [[ -r /etc/os-release ]]; then lsb_dist="$(. /etc/os-release && echo "$ID")"; fi
         package_list="ansible dialog python3-lxml"
         package_listdebian="apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367"
         package_listubuntu="apt-add-repository --yes --update ppa:ansible/ansible"
         if [[ $lsb_dist == 'ubuntu' ]] || [[ $lsb_dist == 'rasbian' ]]; then ${package_listubuntu} 1>/dev/null 2>&1; else ${package_listdebian} 1>/dev/null 2>&1; fi
         for i in ${package_list}; do
            $(command -v apt) install $i --reinstall -yqq 1>/dev/null 2>&1
         done
         if [[ $lsb_dist == 'ubuntu' ]]; then add-apt-repository --yes --remove ppa:ansible/ansible; fi
      fi

      if [[ ! -d "/etc/ansible/inventories" ]]; then
         $(command -v mkdir) -p $invet 
      fi
      cat > /etc/ansible/inventories/local << EOF; $(echo)
## CUSTOM local inventories
[local]
127.0.0.1 ansible_connection=local
EOF
      if [[ -f /etc/ansible/ansible.cfg ]]; then
        $(command -v mv) /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.bak
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

      if [[ "$(systemd-detect-virt)" == "lxc" ]]; then $(command -v bash) /opt/dockserver/preinstall/installer/subinstall/lxc.sh; fi

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
         $(command -v systemctl) reload-or-restart fail2ban.service 1>/dev/null 2>&1
         $(command -v systemctl) enable fail2ban.service 1>/dev/null 2>&1
      fi

      #bad ips mod
      ipset -q flush ips
      ipset -q create ips hash:net
      for ip in $(curl --compressed https://raw.githubusercontent.com/scriptzteam/IP-BlockList-v4/master/ips.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do ipset add ips $ip; done
      iptables -I INPUT -m set --match-set ips src -j DROP
      update-locale LANG=LANG=LC_ALL=en_US.UTF-8 LANGUAGE 1>/dev/null 2>&1
      localectl set-locale LANG=LC_ALL=en_US.UTF-8 1>/dev/null 2>&1

      ## raiselimits
      sed -i '/hard nofile/ d' /etc/security/limits.conf
      sed -i '/soft nofile/ d' /etc/security/limits.conf
      sed -i '$ i\* hard nofile 32768\n* soft nofile 16384' /etc/security/limits.conf
      printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
      break
   done
}
proxydel() {
   delproxy="apache2 nginx"
   for i in ${delproxy}; do
      $(command -v systemctl) stop $i 1>/dev/null 2>&1
      $(command -v systemctl) disable $i 1>/dev/null 2>&1
      $(command -v apt) remove $i -yqq 1>/dev/null 2>&1
      $(command -v apt) purge $i -yqq 1>/dev/null 2>&1
      break
   done
}
oldsinstall() {
   oldsolutions="plexguide cloudbox gooby sudobox sbox pandaura salty"
   for i in ${oldsolutions}; do
      folders="/var/ /opt/ /home/ /srv/"
      for ii in ${folders}; do
         show=$(find $ii -maxdepth 2 -type d -name $i -print)
         if [[ $show != '' ]]; then
            echo ""
            printf "\033[0;31m You need to reinstall your operating system.
sorry, you need a freshly installed server. We can not install on top of $i\033[0m\n"
            echo ""
            read -erp "Type confirm when you have read the message: " input
            if [[ "$input" = "confirm" ]]; then exit; else oldsinstall; fi
         fi
      done
   done
}
# FUNCTIONS END ##############################################################
updatesystem
#E-O-F#
