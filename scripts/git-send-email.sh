#!/bin/sh
# create a patch from last commit

git add -A
git commit
git send-email -1 --to rtmpdump@mplayerhq.hu --subject-prefix 'PATCH v2'
