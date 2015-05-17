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

bra=$(date -d '-1 year' +%Y%m%d)
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
while read wu
do
  let char++
  if [ $char -ge 2 ]
  then
    bk starting link $char
  fi
  awk '
  func z(y) {
    return gensub(/\W/, "\\\\&", "g", y)
  }
  $1 == wu {
    print "upload_date=" z($2), "source=" z($3), "_filename=" z($4)
  }
  ' FS='\t' wu="$wu" ~-/%-new/%.txt > vars.sh
  if [ -s vars.sh ]
  then
    . vars.sh
    printf '%s\nhas already been recorded in archive\n' "$_filename"
    if [ ! -e ~-/%-new/"$_filename" ]
    then
      continue
    fi
    if [ $upload_date -gt $bra ]
    then
      dest=1
    else
      dest=0
    fi
    if [ $source != $dest ]
    then
      echo '[mv] file is now old, moving'
      mv ~-/%-new/"$_filename" ~-/%-old
      awk -i inplace '
      $1 == wu {
        $3 = 0
      }
      1
      ' FS='\t' OFS='\t' wu="$wu" ~-/%-new/%.txt
    fi
  else
    # download
    rm -f *.info.json
    youtube-dl --add-metadata --format m4a/mp3 --output '%(title)s.%(ext)s' \
      --write-info-json --youtube-skip-dash-manifest "$wu"
    jq -r '
    {upload_date, _filename, ext} |
    to_entries |
    map("\(.key)=\(.value | @sh)") |
    .[]
    ' *.info.json > vars.sh
    . vars.sh

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

    if [ $upload_date -gt $bra ]
    then
      dest=1
      delta=%-new
    else
      dest=0
      delta=%-old
    fi
    mv "$_filename" ~-/"$delta"
    set "$wu" "$upload_date" "$dest" "$_filename"
    printf '%s\t%s\t%s\t%s\n' "$@" >> ~-/%-new/%.txt
  fi
done
