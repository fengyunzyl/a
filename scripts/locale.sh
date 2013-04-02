# test command for locale portability

usage ()
{
  echo usage: $0 COMMAND
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

log LANG= $*
log LANG=en_US.CP850 $*
log LANG=en_US.UTF-8 $*
