# backup files

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

usage ()
{
  cp $0 /tmp
  echo usage: /tmp/${0/*\/}
  exit
}

[ ${0::5} = /tmp/ ] || usage

log mkdir cygwin
cd cygwin

items=(
  ~/.bash_history
  /opt
  /usr/local
)

for item in ${items[*]}
do
  set .${item%/*}
  log mkdir -p $1
  log mv $item $1
done
