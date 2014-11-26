function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function say {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  echo "${sx:2}"
}

function log {
  sy=$(say "$@")
  warn "$sy"
  "$@"
}

function hx {
  printf 0x%04x%04x $*
}

function bf {
  regtool set /user/console/ScreenBufferSize $(hx 2000 $1)
  regtool set /user/console/WindowSize       $(hx   22 $1)
  cygstart bash $2
  kill -7 $$ $PPID
}

if (( $# != 2 ))
then
  echo ${0##*/} VIDEO SUB
  exit
fi

ib=${1%.*}

{
  say log ffmpeg -stats -v warning -i "$1" -i "$2" -c:v copy -c:a copy \
    -c:s mov_text "$ib"-subs.mp4
  echo buffer 
} > bf.sh

export -f buffer log say warn
buffer bf.sh

# Invalid UTF-8 in decoded subtitles text; maybe missing -sub_charenc option

# Character encoding subtitles conversion needs a libavcodec built with iconv
# support for this codec

# ffmpeg -i *.mkv -sub_charenc asdf -i *.srt -c:v copy -c:a copy \
#   -c:s mov_text outfile.mp4
