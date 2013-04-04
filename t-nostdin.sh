# figure out where it was lost

usage ()
{
  echo usage: $0 FILENAME
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

[ $1 ] || usage
arg_file=$1
wget ffmpeg.zeranoe.com/builds/win64/static/${arg_file}
P7ZIP="${ProgramW6432}/7-zip/7z"
log "$P7ZIP" e ${arg_file} ${arg_file%.*}/bin/ffmpeg.exe
log ./ffmpeg -v warning -nostdin -y
rm ${arg_file} ffmpeg.exe
