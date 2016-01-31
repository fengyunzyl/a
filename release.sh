#!/bin/sh
ech="\
LOCAL
  1. commit program change
  2. commit version change
  3. tag new version

REMOTE
  1. push commits
  2. push release
"
if [ ! -d .git ]
then
  printf "$ech"
  exit
fi
cd .git
git mktree < /dev/null > fox
git for-each-ref --sort -refname > gol
git diff-tree --numstat fox gol > hot
git diff-tree --numstat gol @ > ind

awk '
function jul(kil, lim) {
  for (mik=100; mik>=1; mik/=10) {
    $++lim = int(kil / mik)
    kil %= mik
  }
  return $0
}
BEGIN {
  OFS = "."
}
FILENAME == ARGV[1] {
  nov = $NF
  nextfile
}
FILENAME == ARGV[2] {
  osc += $1
}
FILENAME == ARGV[3] {
  pap += $1
  que += $2
}
END {
  rom = pap > que ? pap : que
  sie = rom / osc * 100
  if (sie >= 100) tan = 100
  else if (sie >= 10) tan = 10
  else tan = 1
  gsub(/[^[:digit:]]/, "", nov)
  uni = int((nov + tan) / tan) * tan
  printf "old tag = %s\n", jul(nov)
  printf "old tag lines = %d\n", osc
  printf "new tag insertions = %d\n", pap
  printf "new tag deletions = %d\n", que
  printf "%d/%d = %d%\n", rom, osc, sie
  printf "new tag = %s\n", jul(uni)
}
' gol hot ind

rm fox gol hot ind
