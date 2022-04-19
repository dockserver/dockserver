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

### BLA BLA BLA SOME CODE HERE IN THE DOCKER !!

apk update && apk upgrade
apk add rsync curl wget bash

printf "%1s\n" "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer PRE-Install is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
clear && traefikinterface
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
     envmigra && clear

printf "%1s\n" "${yellow}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DockServer [ UPDATE CONTAINER ] DONE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
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

function traefik() {
installed=$($(which docker) ps -aq --format '{{.Names}}' | grep -x 'traefik')
if [[ $installed == "" ]]; then
   overwrite
else
   useraction
fi
}

function useraction() {
printf "%1s\n" "${white}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [ Y ] Force Reset         ( clean Deploy )
  [ N ] No, its a mistake   ( Back to Head Menu )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${normal}"
   read -erp "Are you sure ?: " uaction </dev/tty
   case $uaction in
      y|Y|yes) clear && overwrite ;;
      n|N|no) clear && traefikinterface ;;
      Z|z|c|exit|EXIT|Exit|close) exit 0 ;;
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
127.0.0.1 *.$DOMAIN
127.0.0.1 $DOMAIN" | tee -a /etc/hosts > /dev/null
      fi
      if [[ $DOMAIN != "example.com" ]]; then
         sed -i "s/example.com/$DOMAIN/g" $basefolder/authelia/configuration.yml
         sed -i "s/example.com/$DOMAIN/g" $basefolder/traefik/rules/middlewares.toml
         sed -i "s/example.com/$DOMAIN/g" $basefolder/compose/.env
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
         sed -i "s/<DISPLAYNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
         sed -i "s/<USERNAME>/$DISPLAYNAME/g" $basefolder/authelia/users_database.yml
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
      $(which docker) pull authelia/authelia -q >/dev/null
      PASSWORD=$($(which docker) run authelia/authelia authelia hash-password $PASSWORD -i 2 -k 32 -m 128 -p 8 -l 32 | sed 's/Password hash: //g')
      sed -i "s/<PASSWORD>/$(echo $PASSWORD | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/users_database.yml
   else
      echo "passsword cannot be empty"
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
         sed -i "s/CF-EMAIL/$EMAIL/g" $basefolder/authelia/{configuration.yml,users_database.yml}
         sed -i "s/CF-EMAIL/$EMAIL/g" $basefolder/compose/.env
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
      sed -i "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/authelia/configuration.yml
      sed -i "s/CF-API-KEY/$CFGLOBAL/g" $basefolder/compose/.env
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
      sed -i "s/CF-ZONE_ID/$CFZONEID/g" $basefolder/compose/.env
   else
      echo "CloudFlare Zone ID cannot be empty"
      cfzoneid
   fi
   clear && traefikinterface
}

function serverip() {
   basefolder="/opt/appdata"
   SERVERIP=$(curl -s http://whatismijnip.nl | cut -d " " -f 5)
   if [[ $SERVERIP != "" ]]; then
      sed -i "s/SERVERIP_ID/$SERVERIP/g" $basefolder/authelia/configuration.yml
      sed -i "s/SERVERIP_ID/$SERVERIP/g" $basefolder/compose/.env
   fi
}

function timezone() {
   TZTEST=$($(which timedatectl) && echo true || echo false)
   TZONE=$($(which timedatectl) | grep "Time zone:" | awk '{print $3}')
   if [[ $TZTEST != "false" ]]; then
      if [[ $TZONE != "" ]]; then
         if [[ -f $basefolder/compose/.env ]]; then sed -i '/TZ=/d' $basefolder/compose/.env; fi
         TZ=$TZONE
         grep -qE 'TZ=$TZONE' $basefolder/compose/.env || \
         echo "TZ=$TZONE" >>$basefolder/compose/.env
      fi
   fi
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
   sed -i "s/JWTTOKENID/$(echo $JWTTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   SECTOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
   sed -i "s/unsecure_session_secret/$(echo $SECTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
   ENCTOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
   sed -i "s/encryption_key_secret/$(echo $ENCTOKEN | sed -e 's/[\/&]/\\&/g')/g" $basefolder/authelia/configuration.yml
}

function certs() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env
   echo "Generating SSL certificate for *.$DOMAIN" && \
      $(which docker) pull authelia/authelia && \
      $(which docker) run -a stdout -v $basefolder/traefik/cert:/tmp/certs authelia/authelia authelia certificates generate --host *.${DOMAIN} --dir /tmp/certs/ > /dev/null
}

function deploynow() {
   basefolder="/opt/appdata"
   source $basefolder/compose/.env

   envcreate && \
      certs && \
       secrets && \
         timezone && \
            serverip
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
   d|D) deploynow ;;
   Z|z|exit|EXIT|Exit|close) headinterface ;;
   *) clear && traefikinterface ;;
   esac
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
preinstall
