#!/bin/dash -e
xc() {
  awk '
  BEGIN {
    x = "\47"
    printf "\33[36m"
    while (++i < ARGC) {
      y = split(ARGV[i], z, x)
      for (j in z) {
        printf "%s", z[j] ~ /[^[:alnum:]%+,./:=@_-]/ ? x z[j] x : z[j]
        if (j < y) printf "\\" x
      }
      printf i == ARGC - 1 ? "\33[m\n" : FS
    }
  }
  ' "$@" | fmt -80
  "$@"
}

if [ "$#" != 3 ]
then
  cat <<+
SYNOPSIS
  ff-sequence.sh [start] [duration] [file]

DESCRIPTION
  Make an image sequence from a video
+
  exit
fi

xc ffmpeg -hide_banner -ss "$1" -i "$3" -t "$2" \
-vf "select='eq(pict_type,I)'" -vsync vfr -q 1 %d.jpg
