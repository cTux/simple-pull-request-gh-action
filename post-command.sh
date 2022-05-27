#!/bin/bash

set -e
token=$1
branch=$2
path=$3
repo=$GITHUB_REPOSITORY
username=$GITHUB_ACTOR
branch_name="simple-pr-changes"

if [ -z "$token" ]; then
    echo "Token is not defined."
    exit 1
fi

if [ -z "$branch" ]; then
    echo "Can't find main branch name. Setting it to default."
    branch="main"
    echo "Main branch changed to $branch."
fi

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

echo "Getting diff."
git diff --exit-code >/dev/null 2>&1

if [ $? = 1 ]
then
    echo "Changes detected."
    git remote add authenticated "https://$username:$token@github.com/$repo.git"
    git add -A
    git commit -a -m "new(app): automatic changes" --signoff
    git push authenticated -f
    echo "https://api.github.com/repos/$repo/pulls"
    response=$(curl --write-out "%{message}\n" -X POST -H "Content-Type: application/json" -H "Authorization: token $token" \
         --data '{"title":"new(app): automatic changes","head": "'"$branch_name"'","base":"'"$branch"'", "body":""}' \
         "https://api.github.com/repos/$repo/pulls")
    echo "$response."

    if [[ "$response" == *"already exist"* ]]; then
        echo "Pull request has been already opened. Changes were pushed to the existing PR instead."
        exit 0
    fi
else
    echo "No changes were detected."
    exit 0
fi
