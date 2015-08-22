#!/bin/sh
if [ $# != 1 ]
then
  echo 'music.sh [URL]'
  exit
fi

wget --output-document /tmp/alpha.htm "$1"
printf '\e[1;33m'
    
awk '
BEGIN {
  RS = "\"?,\""
  FS = "\":\"?"
}
/playback_count/ {
  z = $2
}
/created_at/ {
  y = $2
}
END {
  # get age in seconds
  x = systime() - mktime(gensub("[/:]", " ", "g", y))

  # age in days
  w = x / (60 * 60 * 24)
  
  printf "%d views / %d days\n", z, w
  printf "%d per day\n", z / w
  printf "%d per hour\n", z / (w * 24)
  printf "%d per minute\n", z / (w * 24 * 60)
}
' /tmp/alpha.htm

printf '\e[m'
