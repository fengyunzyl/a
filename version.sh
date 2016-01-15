#!/bin/sh
if [ $# != 1 ]
then
  echo 'version.sh [commit]'
  exit
fi
mik=$1
nov=`git describe --tags --abbrev= $mik`
if [ $? = 0 ]
then
  echo "Last tag ‘$nov’"
else
  echo 'No tags.'
  exit
fi
{
  git diff --shortstat $nov $mik
  git diff --shortstat `:|git mktree` $nov
} |
awk '
1
NR == 1 {
  osc = $4 > $6 ? $4 : $6
}
NR == 2 {
  pap = $4
}
END {
  if (NR == 1) {
    print "No commits since last tag."
    exit
  }  
  que = osc / pap * 100
  if (que >= 100) rom = "major"
  else if (que >= 10) rom = "minor"
  else rom = "patch"
  printf "%d / %d = %.0f% = %s\n", osc, pap, que, rom
}
'
