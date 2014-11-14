function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( ! $# ))
then
  echo t-baby-cygwin.sh ZIP [BIN]
  exit
fi

7za x "$1"
cd baby-cygwin/usr/local/bin
if (( $# == 2 ))
then
  log find /git/a /usr/local/bin -maxdepth 1 -type f -exec cp -t. {} +
fi
echo 'baby cygwin ready.'
