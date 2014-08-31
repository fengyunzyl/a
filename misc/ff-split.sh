# split album flac file

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

if (( $# != 2 ))
then
  echo ff-split.sh CUE AUDIO
  exit
fi

arg_cue=$1
arg_aud=$2

# first we need to remux to wav
otf=${arg_aud%.*}.wav
log ffmpeg -i "$arg_aud" -v warning -stats "$otf"
echo

# fpcalc cannot read files with commas, good game
log shntool split -f "$arg_cue" -t %n-%t -m ' -&-(-)-,-/-;-' "$otf"
