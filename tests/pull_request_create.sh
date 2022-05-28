#!/bin/bash

set -e
title="chore(dependencies): updated automatically"
branch_base_name="main"
branch_pr_name="tests-branch-pr"
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
    "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls" \
    --data '{"title":"'"$title"'","head": "'$branch_pr_name'","base":"'$branch_base_name'", "body":"Automatic Pull Request."}' \
)

echo "[ACTION]: Got response: $response."

if [[ "$response" == *"\"message\": \"Validation Failed\""* ]]; then
  exit 1
fi
