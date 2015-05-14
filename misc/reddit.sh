#!/bin/sh
mapfile -t usage <<+
NAME
  reddit.sh

SYNOPSIS
  reddit.sh [URLs]

EXAMPLE URLs
  http://youtube.com/watch?v=qjgnOP8f5NU
  http://soundcloud.com/greco-roman/roosevelt-night-moves
  http://reddit.com/r/stationalpha/new
+

function pa {
  printf '%s\n' "$@"
}

function bk {
  awk '
  BEGIN {
    OFS = "░"
    NF = 80
    printf "\033[1;35m%s\033[m\n", $0
  }
  '
}

if [ $# = 0 ]
then
  pa "${usage[@]}"
  exit
fi

touch %.txt

{
  pa "$@" |
    grep -v reddit
  pa "$@" |
    grep reddit |
    lynx -dump -listonly -nonumbers - '' |
    awk '/Hidden/ {z=1; next} ! $0 {z=0} z'
} |
while read golf
do
  let bravo++ && bk
  kilo=$(awk '$1==golf {print $2}' FS='\t' golf="$golf" %.txt)
  if [ "$kilo" ]
  then
    printf '%s\nhas already been recorded in archive\n' "$kilo"
    continue
  fi

  # download
  youtube-dl --add-metadata --format m4a/mp3 --youtube-skip-dash-manifest \
    --output '%(upload_date)s %(title)s.%(ext)s' "$golf" |
    iconv -f cp1252 | tee /tmp/%.txt
  kilo=$(awk '/Destination/ {print $2}' FS=': ' /tmp/%.txt)
  lima="${kilo/???? / }"
  mv "$kilo" "$lima"

  # faststart
  if [ "${lima##*.}" = m4a ]
  then
    echo '[ffmpeg] moving the moov atom to the beginning of the file'
    ffmpeg -nostdin -v warning -i "$lima" -c copy -movflags faststart \
      -flags global_header outfile.m4a
    mv outfile.m4a "$lima"
  fi

  # gain
  aacgain -k -r -s s -m 10 "$lima"

  printf '%s\t%s\n' "$golf" "$lima" >> %.txt
done
