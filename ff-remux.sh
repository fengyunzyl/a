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
  regtool set /user/console/WindowSize       $(hx   22 $1)
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
  ff-remux.sh [-c choice] [-u] [-a artist] [-t title] [files]

  -u  instead of literal metadata, interpret "-a" and "-t" values as fields for
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
  'ffmpeg -i %q -c copy -vn -movflags faststart %q.m4a'
  'ffmpeg -i %q -c copy -vn -movflags faststart -metadata artist=%q -metadata title=%q %q.m4a'
  'ffmpeg -i %q -vn -b:a 256k -movflags faststart %q.m4a'
  'ffmpeg -i %q -c:v copy -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
  'ffmpeg -i %q -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
)

while getopts c:ua:t: name
do
  case $name in
  c) ci=$OPTARG ;;
  u) let fd++   ;;
  a) ai=$OPTARG ;;
  t) te=$OPTARG ;;
  esac
done
shift $((--OPTIND))

let $# || ug
seq ${#ga[*]} | grep -qx "$ci" || ug
up=${ga[ci-1]}
[[ $up =~ artist ]] && [[ ! $ai ]] && ug
[[ $up =~ title ]] && [[ ! $te ]] && ug

for ip
do
  ib=${ip%.*}
  ie=${ip##*.}
  oe=${up##*.}
  ae[0]=$ip
  if let fd
  then
    ae[1]=$(cut --de "-" --ou " " --fi "$ai" <<< "$ip")
    ae[2]=$(cut --de "-" --ou " " --fi "$te" <<< "$ip")
  elif [[ $up =~ metadata ]]
  then
    ae[1]=$ai
    ae[2]=$te
  fi
  ae[3]=$ib
  [[ $oe = $ie ]] && ae[3]+='~'
  printf -v stage2 "$up" "${ae[@]}"
  let oc++ && ao+=("echo")
  ao+=("log $stage2 -hide_banner")
done
ao+=("warn Press any key to continue...")
ao+=("read")
ao+=("rm rx.sh")
ao+=("bf 80")
printf '%s\n' "${ao[@]}" > rx.sh
export -f bf hx log warn
bf 88 rx.sh
