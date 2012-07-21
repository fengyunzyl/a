#!/bin/bash
# Binary search algorithm

version(){
  url=https://github.com/$1/commit/HEAD~
  u=1
  while wget --spider $url$u; do
    l=$u
    ((u*=2))
  done
  until ((i=(l+u)/2)); [ $i -eq $l ]; do
    wget --spider $url$i && l=$i || u=$i
  done
  echo $i
}

version torvalds/linux

# 41446
# real    1m24.434s
