#!/bin/sh
# This script will push Jekyll branches.
cd /c/home/GitHub/svnpenn.github.com

# Push source branch
git checkout source
git add -A
git commit -m "$(git status -s)"
git push origin source || exit

# Push master branch
jekyll
# Liquid error: No such file or directory
grep -r --color Liquid.error * && exit
git checkout master
git rm -r . >/dev/null
cp -r _site/* .
rm -r _site
git add -A
git commit -m "$(git status -s)"
git push origin master
git checkout source

# Check status
url="svnpenn.github.com/$(git status -s | head -1 | cut -c4-)"
original=$(wget -qO- $url)

while test "$original" = "$(wget -qO- $url)"; do
  for i in {1..10}; do
    # 10 seconds of filler, 10 dots
    printf '.'
    sleep 1
  done
done

printf 'Publish complete!'
