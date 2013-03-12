#!/bin/sh
# MP4 mux

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

nn='
'
while read -rp "Drag file here, or use a pipe.$nn" aa
do
  unquote aa
  bb="${aa%.*}.mp4"
  log ffmpeg -i "$aa" -c copy -nostdin -v warning "$bb"
  log rm "$aa"
done
