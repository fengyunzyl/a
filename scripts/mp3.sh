#!/bin/bash
# MP3 encode
# FIXME ffmpeg -i a.wav -b:a 320k -id3v2_version 3 a.mp3

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

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

printf -v nn '\n'
while read -rp "Drag file here, or use a pipe.$nn" hh
do
  unquote hh
  kk="${hh%.*}.mp3"
  log ffmpeg -i "$hh" -q 0 -v warning "$kk"
  log mp3gain -r -k -m 10 -s s "$kk"
done
