#!/bin/dash
if [ "$#" != 2 ]
then
  echo 'ff-subs.sh [video] [sub]'
  exit
fi

ib=${1%.*}

ffmpeg -stats -v warning -i "$1" -i "$2" -c:v copy -c:a copy \
-c:s mov_text "$ib"-subs.mp4

# Invalid UTF-8 in decoded subtitles text; maybe missing -sub_charenc option

# Character encoding subtitles conversion needs a libavcodec built with iconv
# support for this codec

# ffmpeg -i *.mkv -sub_charenc asdf -i *.srt -c:v copy -c:a copy \
#   -c:s mov_text outfile.mp4
