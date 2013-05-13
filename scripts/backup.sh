# backup files

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
  cp $0 /tmp
  echo usage: /tmp/${0/*\/}
  exit
}

[ ${0::5} = /tmp/ ] || usage

log mkdir cygwin
cd cygwin

for item in /usr/local ~/.bash_history
do
  set .${item%/*}
  log mkdir -p $1
  log mv $item $1
done
