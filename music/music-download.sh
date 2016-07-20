#!/bin/dash -e
pa() {
  for each
  do
    echo "$each"
  done
}

mr() {
  mkdir -p % %-new %-old
  touch %/h.txt %/f.txt %/c.txt
}

if [ $# = 0 ]
then
  cat <<+
SYNOPSIS
  music-download.sh [targets]

TARGETS
  http://youtube.com/watch?v=qjgnOP8f5NU
  http://soundcloud.com/greco-roman/roosevelt-night-moves
  http://reddit.com/r/stationalpha/new
+
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
  char=$((char+1))
  if [ $char -ge 2 ]
  then
    echo starting link $char
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

while IFS=$(printf '\t') read wu upload_date source _filename
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
  echo "$_filename"
  echo '[mv] file is now old, moving'
  mv %-new/"$_filename" %-old
  go=$(mktemp)
  awk '$1 == wu {$3 = 0} 1' FS='\t' OFS='\t' wu="$wu" %/h.txt > "$go"
  mv "$go" %/h.txt
done < %/h.txt
