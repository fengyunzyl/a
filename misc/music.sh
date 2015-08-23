#!/bin/sh
if [ $# != 1 ]
then
  echo 'music.sh [URL]'
  exit
fi

case "$1" in
*soundcloud*)
  v='
  BEGIN {
    RS = "\"?,\""
    FS = "\":\"?"
  }
  /playback_count/ {
    z = $2
  }
  /created_at/ {
    y = gensub("[/:]", " ", "g", $2)
  }
  '
;;
*youtube*)
  v='
  BEGIN {
    FS = "\""
  }
  /interactionCount/ {
    z = $4
  }
  /datePublished/ {
    y = gensub("-", " ", "g", $4) " 0 0 0"
  }
  '
;;
esac

wget --output-document /tmp/alpha.htm "$1"
printf '\e[1;33m'

awk "$v"'
END {
  x = systime() - mktime(y)
  x /= 60 * 60 * 24
  printf "%d views / %d days = %d\n", z, x, z/x
  x *= 24
  printf "%d views / %d hours = %d\n", z, x, z/x
  x *= 60
  printf "%d views / %d minutes = %d\n", z, x, z/x
}
' /tmp/alpha.htm

printf '\e[m'
