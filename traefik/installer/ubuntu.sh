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
      installed=$($(command -v docker) ps -a --format '{{.Names}}' | grep -x 'traefik')
      if [[ $installed == "" ]]; then overwrite; else useraction; fi
      break
   done
}
########## FUNCTIONS START
useraction() {
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [ Y ] Force Reset         ( clean Deploy )
  [ N ] No, its a mistake   ( Back to Head Menu )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   read -erp "Are you sure ?: " uaction </dev/tty
   case $uaction in
   y | Y) clear && overwrite ;;
   n | N) clear && exit ;;
   Z | z | exit | EXIT | Exit | close) exit ;;
   *) useraction ;;
   esac
}
overwrite() {
   basefolder="/opt/appdata"
   source="/opt/dockserver/traefik/templates/"
   envmigrate="/opt/dockserver/apps/.subactions/envmigrate.sh"
   if [[ ! -x $(command -v rsync) ]]; then $(command -v apt) install --reinstall rsync -yqq 1>/dev/null 2>&1; fi
   $(command -v rsync) ${source} ${basefolder} -aqhv --exclude={'local','installer'} && $(command -v bash) $envmigrate
   basefolder="/opt/appdata"
   for i in ${basefolder}; do
      $(command -v mkdir) -p $i/{authelia,traefik} $i/traefik/{rules,acme}
      $(command -v find) $i/{authelia,traefik} -exec $(command -v chown) -hR 1000:1000 {} \;
      $(command -v touch) $i/traefik/acme/acme.json $i/traefik/traefik.log $i/authelia/authelia.log
      $(command -v chmod) 600 $i/traefik/traefik.log $i/authelia/authelia.log $i/traefik/acme/acme.json
   done
   interface
}
domain() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Treafik Domain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     DNS records will not be automatically added
           with the following TLD Domains
           .a, .cf, .ga, .gq, .ml or .tk
     Cloudflare has limited their API so you
          will have to manually add these
   records yourself via the Cloudflare dashboard.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
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
   clear && interface
}
displayname() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Authelia Username
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
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
   clear && interface
}
password() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Authelia Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   read -erp "Enter a password for $USERNAME: " PASSWORD </dev/tty
   if [[ $PASSWORD != "" ]]; then
      $(command -v docker) pull authelia/authelia -q >/dev/null
      PASSWORD=$($(command -v docker) run authelia/authelia authelia crypto hash generate argon2 --password $PASSWORD | sed 's/Digest: //g')
      if [[ $(uname) == "Darwin" ]]; then
         sed -i '' "s/<PASSWORD>/$(echo $PASSWORD | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/users_database.yml
      else
         sed -i "s/<PASSWORD>/$(echo $PASSWORD | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/users_database.yml
      fi
   else
      echo "Password cannot be empty"
      password
   fi
   clear && interface
}
cfemail() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Email-Address
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
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
   clear && interface
}
cfkey() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Global-Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
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
   clear && interface
}
cfzoneid() {
   basefolder="/opt/appdata"
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Cloudflare Zone-ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
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
   clear && interface
}
jounanctlpatch() {
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
serverip() {
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
ccont() {
   container=$($(command -v docker) ps -a --format '{{.Names}}' | grep -E 'trae|auth|error-pag')
   for i in ${container}; do
      $(command -v docker) stop $i 1>/dev/null 2>&1
      $(command -v docker) rm $i 1>/dev/null 2>&1
      $(command -v docker) image prune -af 1>/dev/null 2>&1
   done
}
timezone() {
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
cleanup() {
   listexited=$($(command -v docker) ps -a --format '{{.State}}' | grep -E 'exited' | awk '{print $1}')
   for i in ${listexited}; do
      $(command -v docker) rm $i 1>/dev/null 2>&1
   done
   $(command -v docker) image prune -af 1>/dev/null 2>&1
}
envcreate() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   env0=$basefolder/compose/.env
   if [[ -f $env0 ]]; then
      grep -qE 'ID=1000' $basefolder/compose/.env || \
      echo 'ID=1000' >>$basefolder/compose/.env
   fi
}
secrets() {
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
certs() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   echo "Generating SSL certificate for *.$DOMAIN" && \
      $(command -v docker) pull authelia/authelia && \
      $(command -v docker) run -a stdout -v $basefolder/traefik/cert:/tmp/certs authelia/authelia authelia certificates generate --host *.${DOMAIN} --dir /tmp/certs/ > /dev/null
}
deploynow() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   compose="compose/docker-compose.yml"
   envcreate
   certs
   secrets
   timezone
   cleanup
   jounanctlpatch
   serverip
   ccont
   $(command -v cd) $basefolder/compose/
   if [[ -f $basefolder/$compose ]]; then
      $(command -v docker-compose) config 1>/dev/null 2>&1
      code=$?
      if [[ $code -ne 0 ]]; then
         printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR -> compose check has failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
         read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
         clear && interface
      fi
   fi
   if [[ -f $basefolder/$compose ]]; then
      $(command -v docker-compose) pull 1>/dev/null 2>&1
      code=$?
      if [[ $code -ne 0 ]]; then
         printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR -> compose pull has failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
         read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
         clear && interface
      fi
   fi
   if [[ -f $basefolder/$compose ]]; then
      $(command -v docker-compose) up -d --force-recreate 1>/dev/null 2>&1
      source $basefolder/compose/.env
      printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🚀   Treafik with Authelia
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 	   Treafik with Authelia is deployed
    Please Wait some minutes Authelia and Traefik
     need some minutes to start all services

     Access to the apps are only over https://

        Authelia:   https://authelia.${DOMAIN}
        Traefik:    https://traefik.${DOMAIN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
      sleep 10
      read -erp "Confirm Info | PRESS [ENTER]" typed </dev/tty
      clear && interface
   fi
}

envmigra() {
   envmigrate="/opt/dockserver/apps/.subactions/envmigrate.sh"
   $(command -v bash) $envmigrate
}

######################################################
interface() {
   envmigra
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🚀   Treafik with Authelia over Cloudflare
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [1] Domain                         [ ${DOMAIN} ]
   [2] Authelia Username              [ $DISPLAYNAME ]
   [3] Authelia Password              [ $PASSWORD ]
   [4] CloudFlare-Email-Address       [ ${CLOUDFLARE_EMAIL} ]
   [5] CloudFlare-Global-Key          [ ${CLOUDFLARE_API_KEY} ]
   [6] CloudFlare-Zone-ID             [ ${DOMAIN1_ZONE_ID} ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [D] Deploy Treafik with Authelia

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
   read -erp '↘️  Type Number | Press [ENTER]: ' headtyped </dev/tty
   case $headtyped in
   1) domain ;;
   2) displayname ;;
   3) password ;;
   4) cfemail ;;
   5) cfkey ;;
   6) cfzoneid ;;
   d | D) deploynow ;;
   Z | z | exit | EXIT | Exit | close) exit ;;
   *) clear && interface ;;
   esac
}
# FUNCTIONS END ##############################################################
updatesystem
#"
