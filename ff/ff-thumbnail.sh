#!/bin/bash
# Set thumbnail for MP4 video

unquote() {
  # need quotes for github
  read -r $1 <<< "${!1//\"}"
}

echo 'Careful, screencaps will dump in current directory.
Drag video here, then press enter (backslashes ok).'

read -r j
if [ -z "$j" ]
then
  exit
fi
unquote j
cd "$(dirname "$j")"
j=$(basename "$j")
mp4art --remove "$j"
. <(ffprobe -v 0 -show_streams -of flat=h=0:s=_ "$j")
awk "BEGIN {
  w = $stream_0_width
  h = $stream_0_height
  d = $stream_0_duration
  ar = w / h
  pics = ar > 2 ? 36 : 30
  a = .09 * d
  b = d - a
  interval = (b - a) / (pics - 1)
  for (ss = a; pics-- > 0; ss += interval)
    print ss
}" |
while read ss
do
  printf '%g\r' $ss
  ffmpeg -nostdin -v error -ss $ss -i "$j" -frames 1 $ss.jpg
done

echo 'Drag picture here, then press enter (backslashes ok).'
read -r pc
if [ -z "$pc" ]
then
  exit
fi
unquote pc
# moov could be anywhere in the file, so we cannot use "dd"
mp4art --add "$pc" "$j"
rm *.jpg
