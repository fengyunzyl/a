#!/bin/sh
if [ $# = 0 ]
then
  echo reddit.sh URLS
  exit
fi

# download
lynx -dump -listonly -nonumbers "$@" |
awk '/Hidden/ {$1=""; print}' RS='\n\n' FS='\n' OFS='\n' |
youtube-dl --format bestaudio --download-archive %-download.txt \
--output '%(title)s.%(ext)s' --batch-file -

for each in *.m4a *.mp3
do
  if fgrep "$each" %-fixup.txt
  then
    continue
  fi

  # gain
  aacgain -k -r -s s -m 10 "$each"

  # faststart
  if file --brief --mime-type "$each" | grep audio/x-m4a
  then
    ffmpeg -hide_banner -i "$each" -c copy -movflags faststart outfile.m4a
    mv outfile.m4a "$each"
  fi

  echo "$each" >> %-fixup.txt
done
