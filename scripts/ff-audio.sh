# fix audio stream using FFmpeg
if (( ! $# ))
then
  echo ${0##*/} FILES
  exit
fi

for each
do
  # Apply max noclip gain
  aacgain -r -k -m 10 "$each"
  echo
done

: ffmpeg -i *.mp4 -c:v copy -b:a 256k -af 'pan=stereo|\
  FL < FL + 1.414FC + .5BL + .5SL|\
  FR < FR + 1.414FC + .5BR + .5SR' pan.mp4
