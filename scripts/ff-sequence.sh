#!/bin/sh

usage ()
{
  echo make an image sequence from a video
  echo
  echo usage: $0 START DURATION FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
}

[ $2 ] || usage
log ffmpeg -ss $1 -i $3 -t $2 %d.png
