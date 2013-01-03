#!/bin/bash
# MP3 encode
# FIXME ffmpeg -i a.wav -b:a 320k -id3v2_version 3 a.mp3

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  printf "\e[1;35m%s\e[m\n" "$*"
}

usage ()
{
  echo "Usage:  $0 FILE FILE FILE"
  exit
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=("$oo")
  done
  warn "${pp[@]}"
  eval "${pp[@]}"
}

[ $1 ] || usage

for hh
do
  kk="${hh%.*}.mp3"
  log ffmpeg -i "$hh" -q 1 "$kk"
  log mp3gain -r -k -m 10 "$kk"
done
