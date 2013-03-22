# strip metadata and chapters

usage ()
{
  echo usage: $0 FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
}

[[ $1 ]] || usage
arg_in=$1
arg_out=strip-$arg_in

log ffmpeg -i "$arg_in" -c copy -map_metadata -1 -map_chapters -1 \
  -v warning "$arg_out"