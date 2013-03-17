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

if ! [ -a /bin/coderay ]
then
  echo no coderay
  exit
fi

git checkout master
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
read aa < <(git status -s | cut -c4-)
git status -s | git commit -F-
git push origin master || exit

# Check status
until cmp -s $aa <(wget -qO- svnpenn.github.com/$aa)
do
  for z in {0..9}
  do
    printf $z
    sleep 1
  done
done

git checkout source
echo 'Publish complete!'
