#!/bin/sh
# Binary search algorithm

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 torvalds/linux
  exit
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
    warn $j
    wget --spider $url$j && lw=$j || up=$j
  done
