#!/usr/bin/env bash
URL="https://api.github.com/repos/dockserver/dockserver/releases/latest"
if test -f "./VERSION"; then
   version="$(curl -sX GET "${URL}" | jq -r '.tag_name')"
   version="${version#*v}"
   version="${version#*release-}"
   printf "%s" "${version}"
   if [[ ! -z "${version}" || "${version}" != "null" ]]; then
       echo "${version}" | tee "./VERSION" > /dev/null
       echo "previous ${version}"
   fi
fi
if [[ -n $(git status --porcelain) ]]; then
   git config --global user.name 'github-actions[bot]' 
   git config --global user.email 'github-actions[bot]@users.noreply.github.com' 
   git repack -a -d --depth=750 --window=750
   git add -A
   git commit -sam "#fix publish new version" || exit 0
   git push
fi
