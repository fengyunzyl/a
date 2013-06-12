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

if (( 0x`reg query 'hkcu\console' | awk /nB/,NF=1 FPAT=....$` < 0x58 ))
then
  reg add 'hkcu\console' -f -t reg_dword -v WindowSize -d 0x190058
  reg add 'hkcu\console' -f -t reg_dword -v ScreenBufferSize -d 0x7d00058
  kill -7 $PPID
fi

(( $# )) || usage

declare -A foo=(
                      [0,1]=flac
                      [1,1]=wav
  [2,0]='-c copy -sn' [2,1]=mp4
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
    -i "$baz" ${foo[$REPLY,0]} "${baz%.*}.${foo[$REPLY,1]}"
  echo
done
