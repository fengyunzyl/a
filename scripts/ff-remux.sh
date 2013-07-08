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

d2h ()
{
  printf %04x $*
}

buffer ()
{
  target=$1
  set $(reg query 'hkcu\console' | awk /nB/,NF=1 FPAT='....$') $(d2h $target)
  [ $1 = $2 ] && return
  set reg add 'hkcu\console' -f -t reg_dword
  "$@" -v ScreenBufferSize -d 0x$(d2h 2000 $target)
  "$@" -v WindowSize -d 0x$(d2h 25 $target)
  cygstart bash -l
  kill -7 $$ $PPID
}

buffer 88
(( $# )) || usage

declare -A foo=(
                                           [0,1]=flac
                                           [1,1]=wav
  [2,0]='-c copy'                          [2,1]=mp4
  [3,0]='-c copy -sn'                      [3,1]=mp4
  [4,0]='-c copy -vn -movflags +faststart' [4,1]=m4a
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
