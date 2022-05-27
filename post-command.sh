#!/bin/bash

set -e
token=$1
base_branch_name=$2
path=$3
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
    git commit -a -m "new(app): automatic changes" --signoff
    git push authenticated -f
    echo "https://api.github.com/repos/$repo/pulls"
    response=$(curl --write-out "%{response_code}\n" -X POST -H "Content-Type: application/json" -H "Authorization: token $token" \
         --data '{"title":"new(app): automatic changes","head": "'"$new_branch_name"'","base":"'"$base_branch_name"'", "body":"Automatic PR."}' \
         "https://api.github.com/repos/$repo/pulls")
    echo "Response code: $response."
else
    echo "No changes were detected."
    exit 0
fi
