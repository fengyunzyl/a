#!/bin/bash
# MP3 encode
# FIXME ffmpeg -i a.wav -b:a 320k -id3v2_version 3 a.mp3

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

usage ()
{
  warn "Usage:  ${0##*/} FILE FILE FILE"
  exit
}

try ()
{
  unset gh
  for gg
    do
      [[ "$gg" =~ [\ \&] ]] && gg="\"$gg\""
      gh+=("$gg")
    done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage

for hh
  do
    hi="${hh%.*}.mp3"
    try ffmpeg -i "$hh" -q 1 "$hi"
    try mp3gain -r -k -m 10 "$hi"
  done
