# ffmpeg remux to format of choice

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
r1=(flac)
r2=(wav)
r3=(-c copy flv)
r4=(-c copy mp4)
r5=(-c copy -sn mp4)
r6=(-c copy -vn -movflags faststart m4a)
r7=(-b:a 256k -movflags faststart m4a)
r8=(
  -c:v copy
  -b:a 256k
  -af 'pan=stereo|\
    FL < FL + 1.414FC + .5BL + .5SL|\
    FR < FR + 1.414FC + .5BR + .5SR'
  mp4
)

while {
  (( ee++ ))
  set r$ee[@]
  up=("${!1}")
  (( ${#up} ))
}
do
  bar[ee]=$(say ffmpeg -i infile "${up[@]::${#up[*]}-1}" outfile.${up[*]: -1})
done

select baz in "${bar[@]}"
do
  (( ${#baz} )) && break
done

set r$REPLY[@]
up=("${!1}")

(for baz in "${pm[@]}"
 do
   ie=${baz##*.}
   ob=${baz%.*}
   oe=${up[*]: -1}
   [ $ie = $oe ] && ob+='~'
   say log ffmpeg -stats -v error -i "$baz" "${up[@]::${#up[*]}-1}" "$ob.$oe"
   echo echo
 done
 echo buffer) > rx.sh

export -f buffer log say warn
buffer rx.sh
