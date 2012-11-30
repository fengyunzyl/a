#!/bin/bash
# Should be v1.8.0.1-343-gf94c325

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

usage ()
{
  warn "Usage:  ${0##*/} torvalds/linux"
  exit
}

[ $1 ] || usage
git ls-remote git://github.com/$1.git > j

# Get last tag
read tag < <(tac j | tr / ^ | cut -d^ -f3)

# Get HEAD SHA
read sha < <(cut -c-7 j)

# Get commits to HEAD
wget -Oj https://api.github.com/repos/$1/compare/$tag...HEAD
read commits < <(grep total_commits j | grep -o '[0-9]*')
warn "$tag-$commits-g$sha"
rm j
