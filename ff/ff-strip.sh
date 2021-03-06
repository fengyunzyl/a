#!/bin/dash -e
# strip metadata and chapters
xc() {
  awk '
  BEGIN {
    x = "\47"
    printf "\33[36m"
    while (++i < ARGC) {
      y = split(ARGV[i], z, x)
      for (j in z) {
        printf z[j] ~ /[^[:alnum:]%+,./:=@_-]/ ? x z[j] x : z[j]
        if (j < y) printf "\\" x
      }
      printf i == ARGC - 1 ? "\33[m\n" : FS
    }
  }
  ' "$@"
  "$@"
}

if [ "$#" != 1 ]
then
  echo 'ff-strip.sh [file]'
  exit
fi

j=$1
k=strip.${1##*.}

# "-analyzeduration" doesnt do anything other than remove the warning
xc ffmpeg -hide_banner -i "$j" \
  -vn -c copy -map_metadata -1 -map_chapters -1 "$k"
