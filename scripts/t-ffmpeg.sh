# test FFmpeg
dn="$HOMEDRIVE/steven/videos/breaking bad/season 3"
bn="breaking bad s3e12 half measures.mp4"

./ffmpeg -ss 00:27:00 -i "$dn/$bn" -t 10 -y outfile.mp4
./ffmpeg -v warning -codecs | grep png
