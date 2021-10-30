#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.
source /opt/appdata/compose/.env
basefolder="/opt/appdata"
f2banfilter="/etc/fail2ban/filter.d"
f2banjail="/etc/fail2ban/jail.d"
#### Rework ####
admintoken=$(openssl rand -base64 96)
wget -q https://raw.githubusercontent.com/dani-garcia/bitwarden_rs/master/.env.template -O /opt/appdata/bitwarden/.env
chmod 600 /opt/appdata/bitwarden/.env
touch /opt/appdata/bitwarden/error.log \
      /etc/fail2ban/filter.d/bitwardenrs.conf \
      /etc/fail2ban/jail.d/bitwardenrs.local \
      /etc/fail2ban/filter.d/bitwardenrs-admin.conf \
      /etc/fail2ban/jail.d/bitwardenrs-admin.local
#Set BitWarden fail2ban filter conf File
bitwardenfail2banfilter="$(cat << EOF
[INCLUDES]
before = common.conf
[Definition]
failregex = ^.*Username or password is incorrect\. Try again\. IP: <HOST>\. Username:.*$
ignoreregex =
EOF
)"
echo "${bitwardenfail2banfilter}" > /etc/fail2ban/filter.d/bitwardenrs.conf
#Set BitWarden fail2ban jail conf File
bitwardenfail2banjail="$(cat << EOF
[bitwardenrs]
enabled = true
port = 80,443,8081
filter = bitwarden
action = iptables-allports[name=bitwarden]
logpath = /opt/appdata/bitwarden/error.log
maxretry = 3
bantime = 14400
findtime = 14400
EOF
)"
echo "${bitwardenfail2banjail}" > /etc/fail2ban/jail.d/bitwardenrs.local
#Set BitWarden fail2ban admin filter conf File
bitwardenfail2banadminfilter="$(cat << EOF
[INCLUDES]
before = common.conf
[Definition]
failregex = ^.*Unauthorized Error: Invalid admin token\. IP: <HOST>.*$
ignoreregex =
EOF
)"
echo "${bitwardenfail2banadminfilter}" > /etc/fail2ban/filter.d/bitwardenrs-admin.conf
#Set BitWarden fail2ban admin jail conf File
bitwardenfail2banadminjail="$(cat << EOF
[bitwardenrs-admin]
enabled = true
port = 80,443
filter = bitwarden-admin
action = iptables-allports[name=bitwarden]
logpath = /opt/appdata/bitwarden/error.log
maxretry = 5
bantime = 14400
findtime = 14400
EOF
)"
echo "${bitwardenfail2banadminjail}" > /etc/fail2ban/jail.d/bitwardenrs-admin.local
systemctl restart-or-reload fail2ban
#printf >&2 "Please go to admin url: https://${domain}/admin\n\n"
#printf >&2 "Enter ${admintoken} to gain access, please save this somewhere!!\n\n"
echo "Press any key to finish install of bitwarden"
while [ true ] ; do
      read -t 3 -n 1
         if [ $? = 0 ];then exit;else echo "waiting for the keypress";fi
done
#EOF
