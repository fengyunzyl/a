#!/bin/bash
# MP3 encode
# FIXME ffmpeg -i a.wav -b:a 320k -id3v2_version 3 a.mp3

quote ()
{
  [[ ${!1} =~ \\ ]] && read -r $1 <<< \"${!1}\"
}

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
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

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

# stdin
while read -r -p 'Drag file here, or use a pipe.'$'\n' hh
do
  unquote hh
  kk="${hh%.*}.mp3"
  log ffmpeg -i "$hh" -q 1 -v warning "$kk"
  log mp3gain -r -k -m 10 "$kk"
done
