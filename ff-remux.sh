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
r7=(ffmpeg -i %q -c copy -vn -movflags faststart -metadata title=%q %q.m4a)
r8=(ffmpeg -i %q -b:a 256k -movflags faststart %q.m4a)
r9=(ffmpeg -i %q -c:v copy -b:a 256k -af 'pan=stereo|\
  FL < FL + 1.414FC + .5BL + .5SL|\
  FR < FR + 1.414FC + .5BR + .5SR' %q.mp4)
r10=(ffmpeg -i %q -b:a 256k -af 'pan=stereo|\
  FL < FL + 1.414FC + .5BL + .5SL|\
  FR < FR + 1.414FC + .5BR + .5SR' %q.mp4)

while {
  (( vu++ ))
  set r$vu[@]
  up=("${!1}")
  (( ${#up} ))
}
do
  cm[vu]=$(say "${up[@]}")
done

select wd in "${cm[@]}"
do
  (( ${#wd} )) && break
done

set r$REPLY[@]
up=("${!1}")

(for ip in "${pm[@]}"
 do
   ib=${ip%.*}
   ie=${ip##*.}
   am[0]=$ip
   [[ ${up[*]} =~ metadata ]] && am[1]=${ib//-/ }
   am[2]=$ib
   [[ ${up[*]} =~ $ie ]] && am[2]+='~'
   printf -v stage1 '%q ' "${up[@]}"
   printf -v stage2 "$stage1" "${am[@]}"
   eval say log "$stage2"
   echo echo
 done
 echo buffer) > rx.sh

export -f buffer log say warn
buffer rx.sh
