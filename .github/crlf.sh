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

   git config --global user.name 'github-actions[bot]'
   git config --global user.email 'github-actions[bot]@users.noreply.github.com'

   git pull --rebase
   git config core.autocrlf
   git add . -u
   git commit -sam "[CLRF] Saving files before refreshing line endings"
   git repack -a -d --depth=5000 --window=5000
   git add --renormalize . 
   git commit -m "[CLRF] Normalize all the line endings"
   git push --force
