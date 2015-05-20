#!/bin/bash
mapfile -t usage <<+
NAME
  reddit.sh

SYNOPSIS
  reddit.sh [operation] [targets]

OPERATIONS
  download
    http://youtube.com/watch?v=qjgnOP8f5NU
    http://soundcloud.com/greco-roman/roosevelt-night-moves
    http://reddit.com/r/stationalpha/new

  sync
    sync files to target flash drive, and record all files transferred. If
    sync is run without a target, list available drives and changes since last
    sync.
+

function pa {
  for each
  do
    echo "$each"
  done
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

function dwn {
  if ! type aacgain ffmpeg jq youtube-dl >/dev/null
  then
    exit
  fi
  bra=$(date -d '-1 year' +%Y%m%d)
  mr
  set -o igncr
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
    if fgrep -q "$wu" %/h.txt
    then
      printf '%s\nhas already been recorded in archive\n' "$wu"
      continue
    fi

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
    rm *.info.json vars.sh

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
    mv "$_filename" "$delta"
    set "$wu" "$upload_date" "$dest" "$_filename"
    printf '%s\t%s\t%s\t%s\n' "$@" >> %/h.txt
  done
  while IFS=$'\t' read wu upload_date source _filename
  do
    if [ ! -e %-new/"$_filename" ]
    then
      continue
    fi
    if [ $upload_date -gt $bra ]
    then
      dest=1
    else
      dest=0
    fi
    if [ $source = $dest ]
    then
      continue
    fi
    bk "$_filename"
    echo '[mv] file is now old, moving'
    mv %-new/"$_filename" %-old
    awk -i inplace '
    $1 == wu {
      $3 = 0
    }
    1
    ' FS='\t' OFS='\t' wu="$wu" %/h.txt
  done < %/h.txt
}

function snc {
  if ! type git rsync >/dev/null
  then
    exit
  fi
  mr
  if [ $# = 0 ]
  then
    fd > %/c.txt
    git diff --color %/{f,c}.txt | awk '/^\033\[3[12]m/'
    awk '$3 == "vfat" {print $2}' /etc/mtab
  else
    rsync --archive --delete --verbose --modify-window 2 %-{new,old} "$1"
    fd > %/f.txt
  fi
}

function fd {
  find %-{new,old} -type f -printf '%f\n'
}

function mr {
  mkdir -p %{,-new,-old}
  touch %/{h,f,c}.txt
}

case "$1" in
'download')
  shift
  dwn "$@"
;;
'sync')
  shift
  snc "$@"
;;
*)
  pa "${usage[@]}"
;;
esac
