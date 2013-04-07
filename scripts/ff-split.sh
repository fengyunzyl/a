# split album flac file

usage ()
{
  echo usage: $0 CUE FLAC
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

[[ $2 ]] || usage
arg_cue=$1
arg_flc=$2

# first we need to remux to wav
otf=${arg_flc%.*}.wav
log ffmpeg -i "$arg_flc" -v warning -stats "$otf"
printf '\n'

# fpcalc cannot read files with commas, good game
log shntool split -f "$arg_cue" -t %n-%t -m ,-/- "$otf"
