# make an image sequence from a video

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( $# != 3 ))
then
  echo make an image sequence from a video
  echo
  echo usage: ${0##*/} START DURATION FILE
  exit
fi

log ffmpeg -ss $1 -i $3 -t $2 %d.png
