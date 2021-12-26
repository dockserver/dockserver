#!/usr/bin/env bash

if [[ ! -f "./dockserver/VERSION" ]]; then
   touch "./dockserver/VERSION"
fi

if test -f "./dockserver/VERSION"; then
      version=$(curl -s "https://registry.hub.docker.com/v1/repositories/library/alpine/tags" | jq --raw-output '.[] | select(.name | contains(".")) | .name' | sort -t "." -k1,1n -k2,2n -k3,3n | tail -n1)
      version="${version#*v}"
      version="${version#*release-}"
      printf "%s" "${version}"
      if [[ ! -z "${version}" || "${version}" != "null" ]]; then
         echo "${version}" | tee "./dockserver/VERSION" > /dev/null
         echo "previous ${version}"
      fi
fi
if [[ -n $(git status --porcelain) ]]; then
   git config --global user.name 'github-actions[bot]' 
   git config --global user.email 'github-actions[bot]@users.noreply.github.com' 
   git repack -a -d --depth=500 --window=500
   git add -A
   git commit -sam "#fix publish new version" || exit 0
   git push
fi

