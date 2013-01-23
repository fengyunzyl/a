#!/bin/sh
# Set thumbnail for MP4 video

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo "Usage:  $0 INTERVAL"
  exit
}

quote ()
{
  [[ ${!1} =~ \\ ]] && read -r $1 <<< \"${!1}\"
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=($oo)
  done
  warn ${pp[*]}
  eval ${pp[*]}
}

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

[ $1 ] || usage

warn 'Careful, screencaps will dump in current directory.
Drag video here, then press enter (backslashes ok).'
read -r vd
unquote vd
log atomicparsley "$vd" --artwork REMOVE_ALL --overWrite || exit

j=0
while log ffmpeg -ss $j -i "$vd" -frames 1 -v warning $j.png
do
  [ -a $j.png ] || break
  (( j += $1 ))
done

warn 'Drag picture here, then press enter (backslashes ok).'
read -r pc
unquote pc
log atomicparsley "$vd" --artwork "$pc" --overWrite
ls | grep png | xargs rm -f
