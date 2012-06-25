#!/bin/sh
# Merge commits from another repo

echo 'Enter my user name'
read user

echo 'Enter repo name'
read repo
git clone git@github.com:$user/$repo.git
cd $repo

echo 'Enter repo URL to merge from'
read from_url
git remote add upstream $from_url
git fetch upstream
git branch -a
echo 'Enter name of branch with new commits'
read target_branch

git checkout $target_branch || {
    echo 'Enter starting branch'
    read start_branch
    git checkout $start_branch
    git checkout -b $target_branch
}

# git merge upstream/$target_branch
git push origin $target_branch
