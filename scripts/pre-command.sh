#!/bin/bash

set -e
branch_pr_name=$1

if [ -z "$branch_pr_name" ]; then
    echo "[ACTION]: Can't find changes branch name. Setting it to default."
    branch_pr_name="simple-pr-changes"
    echo "[ACTION]: Changes branch has been changed to $branch_pr_name."
fi

git config --global user.email "noreply@github.com"
git config --global user.name $GITHUB_ACTOR

branch_exists=$(git branch --list $branch_pr_name)

if [ -z "$branch_exists" ]; then
    echo "[ACTION]: Checking out new branch."
    git checkout -b $branch_pr_name
else
    echo "[ACTION]: Branch name $branch_pr_name already exists."
    echo "[ACTION]: Checking out and resetting branch."
    git checkout $branch_pr_name
    git pull
    git reset --hard origin/main
fi
