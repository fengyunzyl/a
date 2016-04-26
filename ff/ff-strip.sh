#!/bin/sh
# strip metadata and chapters

function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  sx=$(sh -xc ': "$@"' . "$@" 2>&1)
  warn "${sx:4}"
  "$@"
}

if [ $# != 1 ]
then
  echo 'ff-strip.sh [file]'
  exit
fi

arg_in=${1}
arg_out=strip.${1/*.}

# "-analyzeduration" doesnt do anything other than remove the warning
log ffmpeg -hide_banner -i "$arg_in" \
  -vn -c copy -map_metadata -1 -map_chapters -1 "$arg_out"
