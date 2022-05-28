#!/bin/bash

set -e
label="dependencies"
label_description="Related to project's dependencies"
color="DF827F"
cd "$PWD/tests"

if [ -f .env ]
then
  # shellcheck disable=SC2046
  # shellcheck disable=SC2002
  export $(cat .env | xargs)
fi

response=$(curl \
    --silent \
    --request POST \
    --header "Accept: application/vnd.github.v3+json" \
    --header "Authorization: token $GITHUB_TOKEN" \
    --header "Content-Type: application/json" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
    --data '{"name":"'"$label"'","description": "'"$label_description"'","color":"'"$color"'"}' \
)

echo "[ACTION]: Got response: $response."

if [[ "$response" == *"\"message\": \"Validation Failed\""* ]]; then
  exit 1
fi
