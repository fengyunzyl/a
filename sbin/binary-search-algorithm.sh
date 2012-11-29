#!/bin/bash
# Binary search algorithm
# torvalds/linux
# 41446
# real    1m24.434s

usage ()
{
  echo "Usage:  ${0##*/} torvalds/linux"
}

[ $1 ] || usage

# HTTPS is faster because no redirect
url=https://github.com/$1/commit/HEAD~
up=1

while wget --spider $url$up
  do
    lw=$up
    ((up *= 2))
  done

until ((j = (lw + up) / 2)); [ $j -eq $lw ]
  do
    wget --spider $url$j && lw=$j || up=$j
  done

echo $j
