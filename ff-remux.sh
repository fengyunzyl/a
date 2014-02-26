# ffmpeg remux to format of choice

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage () {
  echo ${0##*/} FILES
  echo
  echo this will not delete original file
  exit
}

buffer () {
  powershell '&{
  $0 = (gp hkcu:console).ScreenBufferSize -band 0xffff
  if ($0 -eq $args[0]) {exit}
  sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f 2000,$args[0])
  sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f   25,$args[0])
  kill -n bash
  saps bash
  }' $1
}

buffer 88
(( $# )) || usage

declare -A foo=(
                                          [0,1]=flac
                                          [1,1]=wav
  [2,0]='-c copy'                         [2,1]=flv
  [3,0]='-c copy'                         [3,1]=mp4
  [4,0]='-c copy -sn'                     [4,1]=mp4
  [5,0]='-c copy -vn -movflags faststart' [5,1]=m4a
  [6,0]='-b:a 384k   -movflags faststart' [6,1]=m4a
)

for ((ee=0; ${#foo[$ee,1]}; ee++))
do
  bar[ee]="ffmpeg -i infile ${foo[$ee,0]} outfile.${foo[$ee,1]}"
done

select baz in "${bar[@]}"
do
  (( ${#baz} )) && break
done

(( REPLY-- ))

for baz
do
  ie=${baz##*.}
  ob=${baz%.*}
  oe=${foo[$REPLY,1]}
  [ $ie = $oe ] && ob+='~'
  log ffmpeg -stats -v error -i "$baz" ${foo[$REPLY,0]} "$ob.$oe"
  echo
done

buffer 80
