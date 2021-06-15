#!/bin/bash
# This original source of this code: https://github.com/DiscordHooks/travis-ci-discord-webhook
# The same functionality from TravisCI is needed for Github Actions
#
# For info on the GITHUB prefixed variables, visit:
# https://help.github.com/en/articles/virtual-environments-for-github-actions#environment-variables

AVATAR="https://cdn.cominatyou.com/assets/ghb-mk.png"

# More info: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
case ${1,,} in
  "success" )
    EMBED_COLOR=3066993
    STATUS_MESSAGE="Passed"
    ;;

  "failure" )
    EMBED_COLOR=15158332
    STATUS_MESSAGE="Failed"
    ;;

  * )
    STATUS_MESSAGE="Status Unknown"
    EMBED_COLOR=0
    ;;
esac

shift

if [ $# -lt 1 ]; then
  echo -e "WARNING!!\nYou need to pass the WEBHOOK_URL environment variable as the second argument to this script.\nFor details & guide, visit: https://github.com/DiscordHooks/github-actions-discord-webhook" && exit
fi

AUTHOR_NAME="$(git log -1 "$GITHUB_SHA" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$GITHUB_SHA" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$GITHUB_SHA" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$GITHUB_SHA" --pretty="%b")" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g'
COMMIT_URL="https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"

# If, for example, $GITHUB_REF = refs/heads/feature/example-branch
# Then this sed command returns: feature/example-branch
BRANCH_NAME="$(echo $GITHUB_REF | sed 's/^[^/]*\/[^/]*\///g')"
REPO_URL="https://github.com/$GITHUB_REPOSITORY"
BRANCH_OR_PR="Branch"
BRANCH_OR_PR_URL="$REPO_URL/tree/$BRANCH_NAME"
ACTION_URL="$COMMIT_URL/checks"
COMMIT_OR_PR_URL=$COMMIT_URL
if [ "$AUTHOR_NAME" == "$COMMITTER_NAME" ]; then
  CREDITS="$AUTHOR_NAME authored & committed"
else
  CREDITS="$AUTHOR_NAME authored & $COMMITTER_NAME committed"
fi

if [ "$GITHUB_EVENT_NAME" == "pull_request" ]; then
	BRANCH_OR_PR="Pull Request"

	PR_NUM=$(sed 's/\/.*//g' <<< $BRANCH_NAME)
	BRANCH_OR_PR_URL="$REPO_URL/pull/$PR_NUM"
	BRANCH_NAME="#${PR_NUM}"

	# Call to GitHub API to get PR title
	PULL_REQUEST_ENDPOINT="https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/$PR_NUM"

	WORK_DIR=$(dirname ${BASH_SOURCE[0]})
	PULL_REQUEST_TITLE=$(ruby $WORK_DIR/get_pull_request_title.rb $PULL_REQUEST_ENDPOINT)

	COMMIT_SUBJECT=$PULL_REQUEST_TITLE
	COMMIT_MESSAGE="Pull Request #$PR_NUM"
	ACTION_URL="$BRANCH_OR_PR_URL/checks"
	COMMIT_OR_PR_URL=$BRANCH_OR_PR_URL
fi

STATUS=`echo "$STATUS_MESSAGE" | tr "[:upper:]" "[:lower:]"`
c="$GITHUB_REPOSITORY $STATUS"

# "description": "'"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",

TIMESTAMP=$(date -u +%FT%TZ)
WEBHOOK_DATA='{
  "username": "",
  "content": "Build on '$c'.",
  "embeds": [ {
    "color": '$EMBED_COLOR',
    "author": {
      "name": "'"$STATUS_MESSAGE"': '"$WORKFLOW_NAME"' ('"${HOOK_OS_NAME}"') - '"$GITHUB_REPOSITORY"'",
      "url": "'$ACTION_URL'",
      "icon_url": "'$AVATAR'"
    },
    "title": "'"$COMMIT_SUBJECT"'",
    "url": "'"$COMMIT_OR_PR_URL"'",
    "footer": {
      "text": "GitHub Actions"
    },
    "fields": [
      {
        "name": "Commit",
        "value": "'"[\`${GITHUB_SHA:0:7}\`](${COMMIT_URL})"'",
        "inline": true
      },
      {
        "name": "'"$BRANCH_OR_PR"'",
        "value": "'"[${BRANCH_NAME}](${BRANCH_OR_PR_URL})"'",
        "inline": true
      }
    ],
    "timestamp": "'"$TIMESTAMP"'"
  } ]
}'

for ARG in "$@"; do
  echo "Posting webhook...";

  (curl --fail -A "GitHub-Actions-Webhook" -H Content-Type:application/json -d "${WEBHOOK_DATA//	/ }" "$ARG" \
  && echo "Successfully sent the webhook.") || echo "Unable to send webhook."
done