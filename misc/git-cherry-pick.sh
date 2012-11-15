#!/bin/sh

# Topic branch
git checkout master
git branch ksv
git checkout ksv
git apply -p0 ../Patch.diff
git add -A
git commit -m msg

# Partly cherry pick
git checkout svnpenn
# You need "theirs" because cherry-pick is dumb
git cherry-pick -X theirs -n ksv
git reset
git add -p
git commit
git reset --hard
