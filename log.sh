
warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  exec 3>&2 2>log.txt
  unset PS4
  (set -x
    : "$@")
  read k < log.txt
  warn ${k:2}
  exec 2>&3
  "$@"
  rm log.txt
}

log rtmpdump asdf 'asdf asdf'
