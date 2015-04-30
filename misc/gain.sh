#!/bin/sh
# fix audio stream using FFmpeg
mapfile usage <<+
gain.sh FILES

Apply max noclip gain
+
if [ $# = 0 ]
then
  printf '%s\n' "${usage[@]}"
  exit
fi

for each
do
  case ${each: -3} in
  m4a)
    aacgain -k -r -s s -m 10 "$each"
  ;;
  mp3)
    mp3gain -k -r -s s -m 10 "$each"
  ;;
  esac
  echo
done
