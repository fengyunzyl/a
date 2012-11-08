#!/bin/sh
# Keep trying until clean merge

warn(){
  echo -e "\e[1;35m$1\e[m"
}

refa=0
refb=origin/master

until git merge $refb
  do
    warn "origin/svnpenn~$refa fail"
    ((refa++))
    git reset --hard
    git checkout origin/svnpenn~$refa
  done

git reset --hard origin/svnpenn
git checkout svnpenn
warn "origin/svnpenn~$refa success"

# git merge 002e
