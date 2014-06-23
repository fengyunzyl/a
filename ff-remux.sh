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

if (( ! $# ))
then
  echo ${0##*/} FILES
  echo
  echo this will not delete original file
  exit
fi

pm=("$@")
r1=(ffmpeg -i %q %q.wav)
r2=(ffmpeg -i %q %q.flac)
r3=(ffmpeg -i %q -c copy %q.flv)
r4=(ffmpeg -i %q -c copy %q.mp4)
r5=(ffmpeg -i %q -c copy -sn %q.mp4)
r6=(ffmpeg -i %q -c copy %q.m4a)
r7=(ffmpeg -i %q -c copy -vn %q.m4a)
r8=(ffmpeg -i %q -c copy -movflags faststart %q.m4a)
r9=(ffmpeg -i %q -c copy -vn -movflags faststart -metadata title=%q %q.m4a)
r10=(ffmpeg -i %q -b:a 256k -movflags faststart %q.m4a)
r11=(ffmpeg -i %q -c:v copy -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4)
r12=(ffmpeg -i %q -b:a 256k -ac 2 -clev 3dB -slev -6dB %q.mp4)

while {
  (( vu++ ))
  set r$vu[@]
  up=("${!1}")
  (( ${#up} ))
}
do
  ce[vu]=$(say "${up[@]}")
done

select wd in "${ce[@]}"
do
  (( ${#wd} )) && break
done

set r$REPLY[@]
up=("${!1}")

for ip in "${pm[@]}"
do
  ib=${ip%.*}
  ie=${ip##*.}
  am[0]=$ip
  if [[ ${up[*]} =~ metadata ]]
  then
    am[1]=$(sed 's/-/ /g;s/  */ /g' <<< "$ib")
  fi
  am[2]=$ib
  [[ ${up[*]: -1} =~ $ie ]] && am[2]+='~'
  printf -v stage1 '%q ' "${up[@]}"
  printf -v stage2 "$stage1" "${am[@]}"
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
