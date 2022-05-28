#!/bin/bash

set -e
label="dependencies"
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
    "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
)

# echo "[ACTION]: Got response: $response."

if [[ "$response" == *"\"name\": \"$label\""* ]]; then
  echo "[ACTION]: Looks like label has been already created."
else
  echo "[ACTION]: Can't find label."
fi
