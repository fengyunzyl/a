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

function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

function ug {
  hr '
  ff-remux.sh [-c choice] [-u] [-t title] [-a artist] [files]

  -u  instead of literal metadata, interpret "-t" and "-a" values as fields for
      "cut" of input filename

  '
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
  'ffmpeg -i %q -vn -b:a 256k -movflags faststart %q.m4a'
  'ffmpeg -i %q -c:v copy -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
  'ffmpeg -i %q -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
)

while getopts c:ut:a: name
do
  case $name in
  c) ci=$OPTARG ;;
  u) (( fd++ )) ;;
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
  ae[0]=$ip
  if (( fd ))
  then
    ae[1]=$(cut --de "-" --ou " " --fi "$te" <<< "$ip")
    ae[2]=$(cut --de "-" --ou " " --fi "$ai" <<< "$ip")
  elif [[ $up =~ metadata ]]
  then
    ae[1]=$te
    ae[2]=$ai
  fi
  [[ $oe = $ie ]] && ae[3]='~'
  ae[3]+=$ib
  printf -v stage2 "$up" "${ae[@]}"
  unset ae
  (( oc++ )) && ao+=("echo")
  ao+=("log $stage2 -hide_banner")
done
ao+=("warn Press any key to continue...")
ao+=("read")
ao+=("rm rx.sh")
ao+=("bf 80")
printf '%s\n' "${ao[@]}" > rx.sh
export -f bf hx log warn
bf 88 rx.sh
