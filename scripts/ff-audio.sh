# fix audio stream using FFmpeg

# volume
ffmpeg -i a.mkv -filter volumedetect -vn -f null -
ffmpeg -i a.mkv -c:v copy -af volume=3dB -b:a 384k out.mp4

# pan
ffmpeg -i *.mp4 -c:v copy -b:a 256k -af 'pan=stereo|\
  FL < FL + 1.414FC + .5BL + .5SL|\
  FR < FR + 1.414FC + .5BR + .5SR' pan.mp4
