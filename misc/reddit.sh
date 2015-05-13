#!/bin/sh
if [ $# = 0 ]
then
  echo reddit.sh URLS
  exit
fi

touch %-alpha.txt

# download
lynx -dump -listonly -nonumbers "$@" |
awk '/Hidden/ {z=1; next} ! $0 {z=0} z' |
while read golf
do
  let charlie++ && echo
  kilo=$(awk '$1==golf {print $2}' FS='\t' golf="$golf" %-alpha.txt)
  if [ "$kilo" ]
  then
    printf '%s\nhas already been recorded in archive\n' "$kilo"
    continue
  fi

  # download
  youtube-dl --add-metadata --format m4a/mp3 --output '%(title)s.%(ext)s' \
    --youtube-skip-dash-manifest "$golf" | tee %-bravo.txt
  kilo=$(awk '/Destination/ {print $2}' FS=': ' %-bravo.txt)

  # gain
  aacgain -k -r -s s -m 10 "$kilo"

  # faststart
  if file --brief --mime-type "$kilo" | grep -q audio/x-m4a
  then
    ffmpeg -nostdin -hide_banner -v warning -i "$kilo" -c copy \
      -movflags faststart outfile.m4a
    mv outfile.m4a "$kilo"
  fi

  printf '%s\t%s\n' "$golf" "$kilo" >> %-alpha.txt
done
