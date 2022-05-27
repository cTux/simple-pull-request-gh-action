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
    echo "Token is not defined."
    exit 1
fi

if [ -z "$branch_base_name" ]; then
    echo "Can't find main branch name. Setting it to default."
    branch_base_name="main"
    echo "Main branch changed to $branch_base_name."
fi

if [ -z "$branch_pr_name" ]; then
    echo "Can't find changes branch name. Setting it to default."
    branch_pr_name="simple-pr-changes"
    echo "Changes branch changed to $branch_pr_name."
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
    echo "Commit message: $commit_message"
    echo "Head branch: $branch_pr_name"
    echo "Base branch: $branch_base_name"

    response=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: token $token" \
         --data '{"title":"'"$commit_message"'","head": "'$branch_pr_name'","base":"'$branch_base_name'", "body":"Automatic Pull Request."}' \
         "https://api.github.com/repos/$repo/pulls")
    echo "Response: $response"
else
    echo "No changes were detected."
fi
