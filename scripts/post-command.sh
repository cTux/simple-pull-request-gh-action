#!/bin/bash

set -e
token=$1
commit_message=$2
branch_base_name=$3
branch_pr_name=$4
path=$5
repo=$GITHUB_REPOSITORY
username=$GITHUB_ACTOR

if [ -z "$token" ]; then
    echo "[ACTION]: Token is not defined."
    exit 1
fi

if [ -z "$branch_base_name" ]; then
    echo "[ACTION]: Can't find main branch name. Setting it to default."
    branch_base_name="main"
    echo "[ACTION]: Main branch has been changed to $branch_base_name."
fi

if [ -z "$branch_pr_name" ]; then
    echo "[ACTION]: Can't find changes branch name. Setting it to default."
    branch_pr_name="simple-pr-changes"
    echo "[ACTION]: Changes branch has been changed to $branch_pr_name."
fi

if [ -z "$commit_message" ]; then
    echo "[ACTION]: Can't find commit message. Setting it to default."
    commit_message="chore(app): changes"
    echo "[ACTION]: Commit message has been set to $commit_message."
fi

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "[ACTION]: Changing directory to $path_value."
    cd "$path_value"
fi

echo "[ACTION]: Getting diff."
if [[ $(git status --porcelain) ]]; then
    echo "[ACTION]: Changes detected."
    git remote add authenticated "https://$username:$token@github.com/$repo.git"
    git add -A
    git commit -a -m "$commit_message" --signoff
    git push authenticated -f

    response=$(curl \
        --silent \
        --request GET \
        --header "Accept: application/vnd.github.v3+json" \
        --header "Authorization: token $token" \
        "https://api.github.com/repos/$repo/pulls" \
    )

    if [[ "$response" == *"\"title\": \"$commit_message\""* ]]; then
      echo "[ACTION]: Looks like PR has been already created."
    else
      echo "[ACTION]: Creating PR for: https://api.github.com/repos/$repo/pulls"
      echo "[ACTION]: Commit message: $commit_message"
      echo "[ACTION]: Head branch: $branch_pr_name"
      echo "[ACTION]: Base branch: $branch_base_name"

      response=$(curl \
          --silent \
          --request POST \
          --header "Accept: application/vnd.github.v3+json" \
          --header "Authorization: token $token" \
          --header "Content-Type: application/json" \
          "https://api.github.com/repos/$repo/pulls" \
          --data '{"title":"'"$commit_message"'","head": "'$branch_pr_name'","base":"'$branch_base_name'", "body":"Automatic Pull Request."}' \
      )
      echo "[ACTION]: Got response: $response."
    fi
else
    echo "[ACTION]: No changes were detected."
fi
