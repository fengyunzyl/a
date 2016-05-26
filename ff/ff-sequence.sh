#!/bin/dash
if [ "$#" != 1 ]
then
  cat <<+
SYNOPSIS
  ff-sequence.sh [file]

DESCRIPTION
  Make an image sequence from a video
+
  exit
fi

ffmpeg -hide_banner -i "$1" -vf "select='eq(pict_type,I)'" -vsync vfr \
-q 1 %d.jpg
