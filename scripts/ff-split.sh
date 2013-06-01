# split album flac file

usage ()
{
  echo usage: $0 CUE AUDIO
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

[[ $2 ]] || usage
arg_cue=$1
arg_aud=$2

# first we need to remux to wav
otf=${arg_aud%.*}.wav
log ffmpeg -i "$arg_aud" -v warning -stats "$otf"
printf '\n'

# fpcalc cannot read files with commas, good game
log shntool split -f "$arg_cue" -t %n-%t -m ' -&-(-)-,-/-;-' "$otf"
