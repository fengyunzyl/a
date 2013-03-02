#!/bin/bash
# Should be v1.8.0.1-343-gf94c325

usage ()
{
  echo usage: $0 torvalds/linux
  exit
}

[ $1 ] || usage
git ls-remote git://github.com/$1.git > k

# Get last tag
read tag < <(tac k | tr / ^ | cut -d^ -f3)

# Get HEAD SHA
read sha < <(cut -c-7 k)

# Get commits to HEAD
wget -Ok https://api.github.com/repos/$1/compare/$tag...HEAD
read commits < <(grep total_commits k | grep -o '[0-9]*')
echo "$tag-$commits-g$sha"
rm k
