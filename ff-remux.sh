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
  param($cm)
  sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f 2000,$cm)
  sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f   25,$cm)
  }' $(( ${#1} ? 88 : 80 ))
  cygstart bash $1
  kill -7 $$ $PPID
}

ga=(
  'ffmpeg -i %q %q.wav'
  'ffmpeg -i %q %q.flac'
  'ffmpeg -i %q -c copy %q.flv'
  'ffmpeg -i %q -c copy %q.mp4'
  'ffmpeg -i %q -c copy -sn %q.mp4'
  'ffmpeg -i %q -c copy %q.m4a'
  'ffmpeg -i %q -c copy -vn %q.m4a'
  'ffmpeg -i %q -c copy -movflags faststart %q.m4a'
  'ffmpeg -i %q -c copy -vn -movflags faststart -metadata title=%q %q.m4a'
  'ffmpeg -i %q -vn -b:a 256k -movflags faststart %q.m4a'
  'ffmpeg -i %q -c:v copy -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
  'ffmpeg -i %q -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4'
)

if (( $# < 2 )) || ! seq ${#ga[*]} | grep -qx "$1"
then
  echo ${0##*/} CHOICE FILES
  echo
  echo this will not delete original file
  echo
  for each in "${ga[@]}"
  do
    printf '%2s  %s\n' $((++bar)) "$each"
  done
  exit
fi

choice=$1
shift
pm=("$@")
up=${ga[choice-1]}

for ip in "${pm[@]}"
do
  ib=${ip%.*}
  ie=${ip##*.}
  oe=${up##*.}
  am[0]=$ip
  if [[ $up =~ metadata ]]
  then
    am[1]=$(sed 's/-/ /g;s/  */ /g' <<< "$ib")
  fi
  am[2]=$ib
  [[ $oe = $ie ]] && am[2]+='~'
  printf -v stage2 "$up" "${am[@]}"
  (( oc++ )) && ao+=("echo")
  ao+=("log $stage2 -hide_banner")
done
ao+=("warn Press any key to continue . . .")
ao+=("read")
ao+=("rm rx.sh")
ao+=("buffer")
printf '%s\n' "${ao[@]}" > rx.sh
export -f buffer log say warn
buffer rx.sh
