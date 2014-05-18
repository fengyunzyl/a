# test baby cygwin

usage () {
  echo usage: $0 ZIP [BIN]
  exit
}

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

(( $# )) || usage
log unzip -q $1
cd baby-cygwin/usr/local/bin
if (( $# == 2 ))
then
  log find /srv/a /usr/local/bin -maxdepth 1 -type f -exec cp -t. {} +
fi
echo 'baby cygwin ready.'
