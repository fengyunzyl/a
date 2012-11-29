#!/bin/sh
# Merge commits from another branch

git clone git@github.com:svnpenn/rtmpdump.git
cd rtmpdump
git checkout master
git remote add upstream git://git.ffmpeg.org/rtmpdump
git fetch upstream
git merge upstream/master
git push origin master

git checkout pu
git merge master
git push origin pu
