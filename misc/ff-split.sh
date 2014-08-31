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

ce=$1
ao=$2

# fpcalc cannot read files with commas, good game
log shntool split -f "$ce" -t %n-%t -m ' -&-(-)-,-/-;-' -o flac "$ao"

# mux to m4a
dr=$(basename "$PWD")
mkdir "$dr"
for each in *.flac
do
  [[ $each = $ao ]] && continue
  warn "$each"
  ffmpeg -hide_banner -i "$each" -b:a 256k \
    -movflags faststart "$dr"/"${each%.*}".m4a
done
