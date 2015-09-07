#!/bin/sh
: '
<!--Shuffler-oq1a600157-->
'
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
    y = gensub(/[[:alpha:][:punct:]]/, " ", "g", $2)
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
func t(u) {
  printf "%\047.0f views / %\047.0f %s = %\047.0f\n", z, x, u, z/x
}
END {
  x = systime() - mktime(y)
  x /= 60 * 60 * 24
  t("days")
  x *= 24
  t("hours")
  x *= 60
  t("minutes")
}
' /tmp/alpha.htm

printf '\e[m'
