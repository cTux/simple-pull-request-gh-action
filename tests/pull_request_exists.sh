#!/bin/bash

set -e
title="chore(dependencies): updated automatically"
cd "$PWD/tests"

if [ -f .env ]
then
  # shellcheck disable=SC2046
  # shellcheck disable=SC2002
  export $(cat .env | xargs)
fi

response=$(curl \
    --silent \
    --request GET \
    --header "Accept: application/vnd.github.v3+json" \
    --header "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls" \
)

# echo "[ACTION]: Got response: $response."

if [[ "$response" == *"\"title\": \"$title\""* ]]; then
  echo "[ACTION]: Looks like PR has been already created."
else
  echo "[ACTION]: Can't find PR."
fi

if [[ "$response" == *"\"message\": \"Validation Failed\""* ]]; then
  exit 1
fi
