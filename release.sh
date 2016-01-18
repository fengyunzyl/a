#!/bin/sh
mik="\
SYNOPSIS
  release.sh [commit]

LOCAL
  1. commit program change
  2. commit version change
  3. tag new version

REMOTE
  1. push commits
  2. push release
"
if [ $# != 1 ]
then
  printf "$mik"
  exit
fi
nov=$1
osc=`git describe --tags --abbrev= $nov`
if [ $? = 0 ]
then
  echo "Last tag ‘$osc’"
else
  echo 'No tags.'
  exit
fi
{
  git diff --shortstat $osc $nov
  git diff --shortstat `:|git mktree` $osc
} |
awk '
1
NR == 1 {
  pap = $4 > $6 ? $4 : $6
}
NR == 2 {
  que = $4
}
END {
  if (NR == 1) {
    print "No commits since last tag."
    exit
  }  
  rom = pap / que * 100
  if (rom >= 100) sie = "major"
  else if (rom >= 10) sie = "minor"
  else sie = "patch"
  printf "%d / %d = %d% = %s\n", pap, que, rom, sie
}
'
