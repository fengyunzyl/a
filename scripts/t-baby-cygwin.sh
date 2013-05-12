# test baby cygwin

usage ()
{
  echo usage: $0 ZIP
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
log unzip -q $1
cd baby-cygwin/usr/local/bin
log find /opt/a -maxdepth 1 -name '*.sh' -exec cp -t. {} +
echo 'baby cygwin ready.'
