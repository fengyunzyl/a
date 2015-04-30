#!/bin/sh
if [ $# = 0 ]
then
  echo reddit.sh URLS
  exit
fi

# download
lynx -dump -listonly -nonumbers "$@" |
awk '/Hidden/ {$1=""; print}' RS='\n\n' FS='\n' OFS='\n' |
youtube-dl --format bestaudio --download-archive %.txt \
--output '%(title)s.%(ext)s' --batch-file -

# faststart
for each in *.m4a
do
  ffmpeg -hide_banner -i "$each" -c copy -movflags faststart outfile.m4a
  mv outfile.m4a "$each"
done

# gain
for each in *.m4a *.mp3
do
  case "${each: -3}" in
    m4a) gain=aacgain ;;
    mp3) gain=mp3gain ;;
  esac
  "$gain" -k -r -s s -m 10 "$each"
  echo
done
