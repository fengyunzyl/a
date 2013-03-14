#!/bin/bash
# Should be v1.8.0.1-343-gf94c325

usage ()
{
  echo usage: $0 torvalds/linux
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
}

[ $1 ] || usage
git ls-remote git://github.com/$1.git > k

# Get last tag
read tag < <(tac k | tr / ^ | cut -d^ -f3)

# Get HEAD SHA
read sha < <(cut -c-7 k)

# Get commits to HEAD
log wget -qOk https://api.github.com/repos/$1/compare/$tag...HEAD
read commits < <(grep total_commits k | grep -o '[0-9]*')
echo "$tag-$commits-g$sha"
rm k
