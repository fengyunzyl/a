
warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  exec 2> log.txt
  PS4=
  set -x
  : "$@"
  set +x
  read b < log.txt
  b=${b//\'/\"}
  warn ${b:2}
  "$@"
  rm log.txt
}

log mkdir 'asdf asdf' 'qwer qwer'
