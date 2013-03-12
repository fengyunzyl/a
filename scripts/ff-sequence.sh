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

quote ()
{
  yy='[ #&;\]'
  if [[ ${!1} =~ $yy ]]
  then
    read -r $1 <<< \"${!1}\"
  fi
}

log ()
{
  for oo
  do
    quote oo
    set -- "$@" $oo
    shift
  done
  warn $*
  eval $*
}

[ $2 ] || usage
log ffmpeg -ss $1 -i $3 -t $2 %d.png
