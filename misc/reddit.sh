#!/bin/bash
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
  awk -v z="$*" '
  BEGIN {
    y = 79 - length(z)
    x = int(y / 2)
    w = y - x
    printf "\033[1;45m%*s%s%*s\033[m\n", w, "", z, x, ""
  }
  '
}

if [ $# = 0 ]
then
  pa "${usage[@]}"
  exit
fi

if ! type aacgain ffmpeg jq youtube-dl >/dev/null
then
  exit
fi

mkdir -p %-new %-old
touch %-new/%.txt
set -o igncr
cd /tmp

{
  pa "$@" |
    grep -v reddit
  pa "$@" |
    grep reddit |
    lynx -dump -listonly -nonumbers - '' |
    awk '/Hidden/ {z=1; next} ! $0 {z=0} z'
} |
while read bra
do
  let char++
  if [ $char -ge 2 ]
  then
    bk starting link $char
  fi
  del=$(awk '$1==bra {print $2}' FS='\t' bra="$bra" ~-/%-new/%.txt)
  if [ "$del" ]
  then
    printf '%s\nhas already been recorded in archive\n' "$del"
    continue
  fi

  # download
  rm -f *.info.json
  youtube-dl --add-metadata --format m4a/mp3 --output '%(title)s.%(ext)s' \
    --write-info-json --youtube-skip-dash-manifest "$bra"
  jq -r '
  {upload_date, title, _filename, ext} |
  to_entries |
  map("\(.key)=\(.value | @sh)") |
  .[]
  ' *.info.json > info.sh
  . info.sh

  # faststart
  if [ $ext = m4a ]
  then
    echo '[ffmpeg] moving the moov atom to the beginning of the file'
    ffmpeg -nostdin -v warning -i "$_filename" -c copy -movflags faststart \
      -flags global_header temp.m4a
    mv temp.m4a "$_filename"
  fi

  # gain
  aacgain -k -r -s s -m 10 "$_filename"

  fox=$(date -d '-1 year' +%Y%m%d)
  if [ $upload_date -gt $fox ]
  then
    mv "$_filename" ~-/%-new
  else
    mv "$_filename" ~-/%-old
  fi
  printf '%s\t%s\n' "$bra" "$title" >> ~-/%-new/%.txt
done
