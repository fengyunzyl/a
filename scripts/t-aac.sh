# test ffmpeg aac encoder
# 493713

usage ()
{
  echo usage: $0 BITRATE
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

ff ()
{
  log timeout 5 ffmpeg -i $HOMEDRIVE/steven/music/autechre/$1 -c:a aac \
    -strict -2 -v warning -stats -cutoff 17000 -map a -t 10 -b:a $arg_rate \
    -ss $2 -y $3
  [ $? = 0 ] || exit
}

[ $1 ] || usage
arg_rate=$1

ff oversteps/Oversteps-007-Autechre-Treale.flac 00:00:25 treale.m4a

ff oversteps/Oversteps-005-Autechre-qplay.flac 00:03:06 qplay.m4a

ff oversteps/Oversteps-002-Autechre-ilanders.flac 00:01:09 ilanders.m4a

ff exai/Exai-001-Autechre-Fleure.flac 0 fleure.m4a

ff incunabula-flac/Incunabula-009-Autechre-Windwind.flac 00:03:00 wind.m4a

ff oversteps/Oversteps-014-Autechre-Yuop.flac 00:03:10 yuop.m4a
