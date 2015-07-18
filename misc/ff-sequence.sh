#!/bin/sh
function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  sx=$(bash -xc ': "$@"' . "$@" 2>&1)
  warn "${sx:4}"
  "$@"
}

if [ $# != 4 ]
then
  echo make an image sequence from a video
  echo
  echo 'ff-sequence.sh START DURATION FILE <png|jpg>'
  exit
fi

log ffmpeg -hide_banner -ss $1 -i "$3" -t $2 -q 1 %d.$4
