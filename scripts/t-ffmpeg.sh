# test FFmpeg

set 'Breaking Bad - S03E12 - Half Measures.mp4'
./ffmpeg -i "c:/steven/videos/breaking bad/season 3/$1" -t 10 -y outfile.mp4
./ffmpeg -v warning -codecs | grep png
