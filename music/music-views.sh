#!/bin/dash -e
if [ "$#" != 1 ]
then
  echo 'music-views.sh [URL]'
  exit
fi
fox=$1

case $fox in
*soundcloud*)
  gol='
  BEGIN {
    RS = "\"?,\""
    FS = "\":\"?"
  }
  /playback_count/ {
    hot = $2
  }
  /created_at/ {
    ind = gensub(/[[:alpha:][:punct:]]/, " ", "g", $2)
  }
  '
;;
*youtube*)
  gol='
  BEGIN {
    FS = "\""
  }
  /interactionCount/ {
    hot = $4
  }
  /datePublished/ {
    ind = gensub("-", " ", "g", $4) " 0 0 0"
  }
  '
;;
esac

jul=$(mktemp)
wget -O "$jul" "$fox"
printf '\33[1;33m'

awk "$gol"'
function kil(lim, mik) {
  printf "%\47.0f views / %\47.*f %s = %\47.0f\n", hot, mik, nov, lim, hot/nov
}
END {
  nov = systime() - mktime(ind)
  nov /= 60 * 60 * 24 * 365
  kil("years", 3)
  nov *= 365
  kil("days")
  nov *= 24
  kil("hours")
  nov *= 60
  kil("minutes")
}
' "$jul"

printf '\33[m'
