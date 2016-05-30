#!/bin/dash
if [ "$#" != 1 ]
then
  echo 'music.sh [URL]'
  exit
fi

case $1 in
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

wget --output-document /tmp/alfa.htm "$1"
printf '\33[1;33m'

awk "$v"'
function s(t, u) {
  printf "%\47.0f views / %\47.*f %s = %\47.0f\n", z, u, x, t, z/x
}
END {
  x = systime() - mktime(y)
  x /= 60 * 60 * 24 * 365
  s("years", 3)
  x *= 365
  s("days")
  x *= 24
  s("hours")
  x *= 60
  s("minutes")
}
' /tmp/alfa.htm

printf '\33[m'
