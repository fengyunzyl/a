#!/bin/sh
# create high quality video from song and picture

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

quote ()
{
  yy='[ #&;\]'
  if [[ ${!1} =~ $yy ]]
  then
    read -r $1 <<< \"${!1}\"
  fi
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
  echo usage: $0 IMAGE
  exit
}

[ $1 ] || usage
nn='
'
while read -rp "Drag song here, or use a pipe.$nn" hh
do
  unquote hh
  kk="${hh%.*}.mp4"
  # adding "-preset" would only make small difference in size or speed
  # make sure input picture is at least 720
  log ffmpeg -loop 1 -i "$1" -i "$hh" -shortest -qp 0 -v warning -nostdin \
    -c:a aac -strict -2 -b:a 529200 "$kk"
done
