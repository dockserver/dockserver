#!/usr/bin/with-contenv bash

sudo wget -qO- https://raw.githubusercontent.com/dockserver/dockserver/master/scripts/security/badips.sh | sudo bash -v
sudo wget -O /opt/appdata/traefik/bann.sh https://raw.githubusercontent.com/dockserver/dockserver/master/scripts/security/traefik-bann.sh

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


printf "${RED}dockserver.github.io Security Patch\n${NC} code @ doob1987\n"
