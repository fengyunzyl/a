#!/bin/sh
# Merge commits from another branch

git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout master
git branch ksv
git checkout ksv
git apply -p0 ../Patch.diff
git status -s >/tmp/s
git add -A
git commit -F- </tmp/s
git checkout handshake-10
git merge -X theirs ksv
