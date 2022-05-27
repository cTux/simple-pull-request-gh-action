#!/bin/bash

set -e
branch_pr_name=$1
path=$2
username=$GITHUB_ACTOR
email="noreply@github.com"

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

if [ -z "$branch_pr_name" ]; then
    echo "Can't find changes branch name. Setting it to default."
    branch_pr_name="simple-pr-changes"
    echo "Changes branch changed to $branch_pr_name."
fi

git config --global user.email $email
git config --global user.name $username

branch_exists=$(git branch --list $branch_pr_name)

if [ -z "$branch_exists" ]; then
    echo "Check out new branch."
    git checkout -b $branch_pr_name
else
    echo "Branch name $branch_pr_name already exists."
    echo "Check out and reset branch instead."
    git checkout $branch_pr_name
    git pull
    git reset --hard origin/main
fi
