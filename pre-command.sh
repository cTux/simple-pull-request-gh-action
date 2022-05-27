#!/bin/bash

set -e
branch_name="simple-pr-changes"

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
