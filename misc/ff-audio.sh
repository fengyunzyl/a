# fix audio stream using FFmpeg
if (( ! $# ))
then
  echo ${0##*/} FILES
  exit
fi

for each
do
  # Apply max noclip gain
  aacgain -k -r -s s -m 10 "$each"
  echo
done
