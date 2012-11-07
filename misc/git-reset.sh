#!/bin/sh
# Keep trying until clean merge

warn(){
  echo -e "\e[1;35m$1\e[m"
}

refa=0
refb=origin/master

until git merge $refb
  do
    warn "svnpenn~$refa fail"
    ((refa++))
    git reset --hard
    git checkout svnpenn~$refa
  done

git reset --hard origin/svnpenn
git checkout svnpenn
warn "svnpenn~$refa success"

# git reset --hard svnpenn~14
# git merge origin/master
# Merge my commits back in
# git merge 0d1c
