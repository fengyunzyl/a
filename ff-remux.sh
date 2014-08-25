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

function hx {
  printf 0x%04x%04x $*
}

function bf {
  regtool set /user/console/ScreenBufferSize $(hx 2000 $1)
  regtool set /user/console/WindowSize       $(hx   25 $1)
  cygstart bash $2
  kill -7 $$ $PPID
}

function ug {
  echo ${0##*/} [-c choice] [-t title] [-a artist] [files]
  for each in "${ga[@]}"
  do
    printf '%2s  %s\n' $((++bar)) "$each"
  done
  exit
}

ga=(
  'ffmpeg -i %q %q.wav'
  'ffmpeg -i %q %q.flac'
  'ffmpeg -i %q -c copy %q.flv'
  'ffmpeg -i %q -c copy %q.mp4'
  'ffmpeg -i %q -c copy -sn %q.mp4'
  'ffmpeg -i %q -c copy %q.m4a'
  'ffmpeg -i %q -c copy -vn %q.m4a'
  'ffmpeg -i %q -c copy -vn %q.mp3'
  'ffmpeg -i %q -c copy -movflags faststart %q.m4a'
  'ffmpeg -i %q -c copy -vn -movflags faststart -metadata title=%q \
    -metadata artist=%q %q.m4a'
  'ffmpeg -i %q -b:a 256k -movflags faststart -metadata title=%q %q.m4a'
  'ffmpeg -i %q -vn -b:a 256k -movflags faststart %q.m4a'
  'ffmpeg -i %q -c:v copy -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
  'ffmpeg -i %q -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
)

while getopts c:t:a: name
do
  case $name in
  c) ci=$OPTARG ;;
  t) te=$OPTARG ;;
  a) ai=$OPTARG ;;
  esac
done
shift $((--OPTIND))

(( $# )) || ug
seq ${#ga[*]} | grep -qx "$ci" || ug
up=${ga[ci-1]}
[[ $up =~ title ]] && [[ ! $te ]] && ug
[[ $up =~ artist ]] && [[ ! $ai ]] && ug

for ip
do
  ib=${ip%.*}
  ie=${ip##*.}
  oe=${up##*.}
  am[0]=$ip
  if [[ $up =~ title ]]
  then
    am[1]=$te
  fi
  if [[ $up =~ artist ]]
  then
    am[2]=$ai
  fi
  am[3]=$ib
  [[ $oe = $ie ]] && am[2]+='~'
  printf -v stage2 "$up" "${am[@]}"
  (( oc++ )) && ao+=("echo")
  ao+=("log $stage2 -hide_banner")
done
ao+=("warn Press any key to continue . . .")
ao+=("read")
ao+=("rm rx.sh")
ao+=("bf 80")
printf '%s\n' "${ao[@]}" > rx.sh
export -f bf hx log warn
bf 88 rx.sh
