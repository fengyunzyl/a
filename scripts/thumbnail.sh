#!/bin/sh
# Set thumbnail for MP4 video

warn ()
{
  printf "\e[1;35m%s \e[m" "$@"
  printf "\n"
}

usage ()
{
  echo "Usage:  $0 INTERVAL"
  exit
}

quote ()
{
  ! [[ ${!1} =~ \" ]] && [[ ${!1} =~ \\ ]] && read -r $1 <<< \"${!1}\"
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
warn 'Drag video here, then press enter (backslash ok)'
read -r vd
log atomicparsley "$vd" --artwork REMOVE_ALL --overWrite || exit

j=0
while log ffmpeg -ss $j -i "$vd" -frames 1 -v warning /tmp/$j.png
do
  [ -a /tmp/$j.png ] || break
  (( j += $1 ))
done

warn 'Drag picture here, then press enter (backslash ok)'
read -r pc
log atomicparsley "$vd" --artwork "$pc" --overWrite
find /tmp -mindepth 1 | xargs rm -f
