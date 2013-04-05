# test ffmpeg aac encoder
# 487167

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
    -strict -2 -v error -stats -cutoff 17000 -map a -t 10 -b:a $arg_rate \
    -ss $2 -y $3
  if [ $? = 0 ]
  then
    printf '\nPASS\n'
  else
    printf '\nFAIL\n'
    exit
  fi
}

[ $1 ] || usage
arg_rate=$1

ff chiastic-slide-flac/09-Nuane.flac 5 nuane.m4a

ff chiastic-slide-flac/04-Cichli.flac 00:03:15 cichli.m4a

ff Tri-Repetae-flac/07-C-Pach.flac 00:03:44 c-pach.m4a

ff oversteps/Oversteps-007-Autechre-Treale.flac 00:02:54 treale.m4a

ff oversteps/Oversteps-005-Autechre-qplay.flac 00:03:06 qplay.m4a

ff oversteps/Oversteps-002-Autechre-ilanders.flac 00:01:09 ilanders.m4a

ff exai/Exai-001-Autechre-Fleure.flac 0 fleure.m4a

ff incunabula-flac/Incunabula-009-Autechre-Windwind.flac 00:03:00 wind.m4a

ff oversteps/Oversteps-014-Autechre-Yuop.flac 00:03:10 yuop.m4a
