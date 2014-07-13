# strip metadata and chapters

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

if (( $# != 1 ))
then
  echo ${0##*/} FILE
  exit
fi

arg_in=${1}
arg_out=strip.${1/*.}

# "-analyzeduration" doesnt do anything other than remove the warning
log ffmpeg -i "$arg_in" -c copy -map_metadata -1 -map_chapters -1 "$arg_out" \
  -hide_banner
