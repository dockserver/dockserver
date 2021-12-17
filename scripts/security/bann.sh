#!/usr/bin/with-contenv bash

  cat > /opt/appdata/traefik/bann.sh << EOF; $(echo)
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
apt -qq install iptables ipset
ipset -q flush ips
ipset -q create ips hash:net
for ip in $(curl --compressed https://raw.githubusercontent.com/scriptzteam/IP-BlockList-v4/master/ips.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do ipset add ips $ip; done
iptables -I INPUT -m set --match-set ips src -j DROP

sleep 5

export logfile=/opt/appdata/traefik/traefik.log
while true;do
  tail -n 15 "${logfile}" | grep --line-buffered '/_ignition/execute-solution' | sed '/banned/d' | awk '{print $1}'  | while read line; do
     iptables -A INPUT -s $line -j DROP
     sed -i "s#$line#banned#g" "${logfile}"
     sleep 5
  done
  tail -n 50 "${logfile}" | grep --line-buffered '/?x=${jndi:' | sed '/banned/d' | awk '{print $1}'  | while read line; do
     iptables -A INPUT -s $line -j DROP
     sed -i "s#$line#banned#g" "${logfile}"
     sleep 5
  done
 sleep 5
done
EOF

if [[ ! $(which screen) ]]; then
   $(command -v apt) install screen -yqq && \
   screen -S bannbadips -dm bash -xv /opt/appdata/traefik/bann.sh
else
   screen -S bannbadips -dm bash -xv /opt/appdata/traefik/bann.sh
fi

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
RED='\033[0;31m'
NC='\033[0m' # No Color


printf "${RED}DockServer.io Security Patch\n${NC} code @ doob1987\n"
