#!/bin/bash

set -e
token=$1
commit_message=$2
base_branch_name=$3
path=$4
repo=$GITHUB_REPOSITORY
username=$GITHUB_ACTOR
new_branch_name="simple-pr-changes"

if [ -z "$token" ]; then
    echo "Token is not defined."
    exit 1
fi

if [ -z "$base_branch_name" ]; then
    echo "Can't find main branch name. Setting it to default."
    base_branch_name="main"
    echo "Main branch changed to $base_branch_name."
fi

if [ -z "$commit_message" ]; then
    echo "Can't find commit message. Setting it to default."
    commit_message="chore(app): changes"
    echo "Commit message is set to $commit_message."
fi

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

echo "Getting diff."
if [[ $(git status --porcelain) ]];
then
    echo "Changes detected."
    git remote add authenticated "https://$username:$token@github.com/$repo.git"
    git add -A
    git commit -a -m "$commit_message" --signoff
    git push authenticated -f
    echo "https://api.github.com/repos/$repo/pulls"
    response=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: token $token" \
         --data '{"title":"'"$commit_message"'","head": "'$new_branch_name'","base":"'$base_branch_name'", "body":"Automatic Pull Request."}' \
         "https://api.github.com/repos/$repo/pulls")
    echo "Response: $response"
else
    echo "No changes were detected."
    exit 0
fi
