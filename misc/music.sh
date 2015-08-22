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

  x /= 60 * 60 * 24
  printf "%d views / %d days = %d\n", z, x, z/x

  x *= 24
  printf "%d views / %d hours = %d\n", z, x, z/x

  x *= 60
  printf "%d views / %d minutes = %d\n", z, x, z/x
}
' /tmp/alpha.htm

printf '\e[m'
