#!/bin/bash
# This script will push Jekyll branches.
cd /opt/svnpenn.github.com

# Push source branch
git checkout source
git add -A
git status -s | git commit -F-
git push origin source || exit

# Push master branch
jekyll build || exit
grep --color -r 'Liquid.error' . && exit
command -v coderay || exit
git checkout master
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
read aa < <(git status -s | cut -c4-)
git status -s | git commit -F-
git push origin master || exit

# Check status
check ()
{
  until cmp -s $1 <(wget -qO- $2)
  do
    for z in {0..9}
    do
      printf $z
      sleep 1
    done
  done
}
check $aa svnpenn.github.com/$aa
git checkout source
echo 'Publish complete!'
