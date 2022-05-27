#!/bin/bash

set -e
path=$1
branch_name="simple-pr-changes"
username=$GITHUB_ACTOR
email="noreply@github.com"

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

git config --global user.email $email
git config --global user.name $username

echo "Fetching."
git fetch
branch_exists=$(git branch --list simple-pr-changes)
echo "Branch exists $branch_exists."

if [ -z "$branch_exists" ]; then
    echo "Check out new branch."
    git checkout -b $branch_name
else
    echo "Branch name $branch_name already exists."
    echo "Check out and reset branch instead."
    git checkout $branch_name
    git pull
    git reset --hard origin/main
fi
