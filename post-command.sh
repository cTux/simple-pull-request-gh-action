#!/bin/bash

set -e
token=$1
echo "Token $token."
branch_main=$2
echo "Main branch $branch_main."
repo=$GITHUB_REPOSITORY
echo "Repo $repo."
username=$GITHUB_ACTOR
echo "Username $username."
branch_name="simple-pr-update"
email="noreply@github.com"

if [ -z "$token" ]; then
    echo "Token is not defined."
    exit 1
fi

if [ -z "$branch_main" ]; then
    echo "Can't find main branch name. Settings default."
    branch_main="main"
    echo "Main branch changed to $branch_main."
fi

echo "Getting diff."
git diff --exit-code >/dev/null 2>&1

if [ $? = 1 ]
then
    echo "Changes detected."
    git config --global user.email "$email"
    git config --global user.name "$username"
    git remote add authenticated "https://$username:$token@github.com/$repo.git"
    git add -A
    git commit -a -m "new(app): automatic changes" --signoff
    git push authenticated -f
    echo "https://api.github.com/repos/$repo/pulls"
    response=$(curl --write-out "%{message}\n" -X POST -H "Content-Type: application/json" -H "Authorization: token $token" \
         --data '{"title":"new(app): automatic changes","head": "'"$branch_name"'","base":"'"$branch_main"'", "body":""}' \
         "https://api.github.com/repos/$repo/pulls")
    echo "$response."

    if [[ "$response" == *"already exist"* ]]; then
        echo "Pull request has been already opened. Updates were pushed to the existing PR instead."
        exit 0
    fi
else
    echo "No changes were detected."
    exit 0
fi
