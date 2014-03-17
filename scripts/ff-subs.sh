warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

say () {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  echo "${sx:2}"
}

log () {
  sy=$(say "$@")
  warn "$sy"
  "$@"
}

buffer () {
  powershell '&{
  sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f 2000,$args[0])
  sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f   25,$args[0])
  }' $(( ${#1} ? 88 : 80 ))
  cygstart bash $1
  kill -7 $PPID
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
