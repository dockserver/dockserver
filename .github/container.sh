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

   export USERNAME=${username}
   export TOKEN=${token}
   curl -u $USERNAME:$TOKEN -o "./wiki/docs/install/github-metrics.svg" -L "https://raw.githubusercontent.com/dockserver/container/master/github-metrics.svg"
   curl -u $USERNAME:$TOKEN -o "./wiki/docs/install/container.md" -L "https://raw.githubusercontent.com/dockserver/container/master/wiki/docs/install/container.md"
   curl -u $USERNAME:$TOKEN -o "./wiki/docs/install/container.json" -L "https://raw.githubusercontent.com/dockserver/container/master/wiki/docs/install/container.json"
   curl -u $USERNAME:$TOKEN -o "./wiki/docs/install/container-gitlog.md" -L "https://raw.githubusercontent.com/dockserver/container/master/wiki/docs/install/container-gitlog.md"

   #### 
   unset TOKEN USERNAME
   git config --global user.name 'github-actions[bot]'
   git config --global user.email 'github-actions[bot]@users.noreply.github.com'
   git repack -a -d --depth=5000 --window=5000
   git add -A && git commit -sam "[Auto] Adding new index version" || exit 0
   git push --force
