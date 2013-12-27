# increase video volume

# detect
ffmpeg -i a.mkv -filter volumedetect -vn -f null -

# increase
ffmpeg -i a.mkv -c:v copy -af volume=3dB -b:a 384k out.mp4
