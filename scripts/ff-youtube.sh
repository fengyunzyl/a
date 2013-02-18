#!/bin/sh
# create high quality video from song and picture

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

quote ()
{
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
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

usage ()
{
  echo usage: $0 IMAGE [SONGS]
  exit
}

[ $1 ] || usage
nn='
'
while read -r -p "Drag song here, or use a pipe.$nn" hh
do
  unquote hh
  kk="${hh%.*}.mkv"
  # adding "-preset" would only make small difference in size or speed
  log ffmpeg -loop 1 -i "$1" -i "$hh" -vf scale=-1:720 -c:a copy -shortest \
    -qp 0 -v warning -nostdin "$kk"
done
