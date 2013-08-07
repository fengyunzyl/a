# ffmpeg remux to format of choice

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage ()
{
  echo usage: $0 FILES
  echo
  echo this will not delete original file
  exit
}

buffer ()
{
  set $1 $(reg query 'hkcu\console' | grep ScreenBufferSize)
  [ $(( $4 & 0xffff )) = $1 ] && return
  set $(printf '%04x ' $1 2000 25)
  reg add 'hkcu\console' -f -t reg_dword -v ScreenBufferSize -d 0x$2$1
  reg add 'hkcu\console' -f -t reg_dword -v WindowSize -d 0x$3$1
  cygstart bash -l
  kill -7 $$ $PPID
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
)

(( ee = 0 ))
while [ ${foo[$ee,1]} ]
do
  bar[ee]="ffmpeg -i infile ${foo[$ee,0]} outfile.${foo[$ee,1]}"
  (( ee++ ))
done

select baz in "${bar[@]}"
do
  [[ $baz ]] && break
done

(( REPLY-- ))

for baz
do
  log ffmpeg -stats -v error \
    -i "$baz" ${foo[$REPLY,0]} "${baz%.*}~.${foo[$REPLY,1]}"
  echo
done

buffer 80
