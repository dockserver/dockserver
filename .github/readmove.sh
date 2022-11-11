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

   curl -o "./wiki/docs/index.md" -L "https://raw.githubusercontent.com/dockserver/dockserver/master/README.md"
   git config --global user.name 'github-actions[bot]'
   git config --global user.email 'github-actions[bot]@users.noreply.github.com'
   git repack -a -d --depth=5000 --window=5000
   git add -A && git commit -sam "[Aut] Adding new index version" || exit 0
   git push --force

