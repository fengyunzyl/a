#!/bin/sh

# Create new files
git merge -X theirs master
git cherry-pick -X theirs -n ksv
git reset
git add -p
git commit

# Merge in new files
git merge -X patience master
cp ../parseurl.c librtmp
cp ../rtmp.c librtmp
cp ../rtmpsrv.c .
git commit -a
