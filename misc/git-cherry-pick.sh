#!/bin/sh
# git cherry pick

git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout svnpenn
git cherry-pick -X theirs 002e
