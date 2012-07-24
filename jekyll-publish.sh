#!/bin/bash
# This script will push Jekyll branches.
cd /opt/svnpenn.github.com

# Push source branch
git checkout source
git add -A
git status -s | git commit -F-
git push origin source || exit

# Push master branch
jekyll
grep --color -r 'Liquid.error' . && exit
git checkout master
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
read s f < <(git status -s)
git status -s | git commit -F-
git push origin master || exit

# Check status
check(){
  until cmp -s $1 <(wget -qO- $2); do
    for i in {0..9}; do echo -n $i; sleep 1; done
  done
}
check $f svnpenn.github.com/$f
git checkout source
echo 'Publish complete!'
