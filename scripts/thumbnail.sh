#!/bin/sh
# Set thumbnail for MP4 video

warn ()
{
  printf "\e[1;35m%s \e[m" "$@"
  printf "\n"
}

usage ()
{
  echo "Usage:  $0 FILE"
  exit
}

quote ()
{
  [[ ${!1} =~ \\ ]] && read -r $1 <<< \"${!1}\"
}

log ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage
find /tmp -mindepth 1 | xargs rm -f

j=0
while log ffmpeg -ss $j -i "$1" -frames:v 1 -v warning /tmp/$j.png
do
  [ -a /tmp/$j.png ] || break
  (( j += 20 ))
done

log atomicparsley "$1" --artwork REMOVE_ALL --overWrite || exit
warn 'Drag picture here, then press enter (backslash ok)'
read -r
log atomicparsley "$1" --artwork "$REPLY" --overWrite
