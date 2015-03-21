function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
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
