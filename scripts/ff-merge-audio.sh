#!/bin/sh
# Merge audio!
# ffmpeg.org/ffmpeg.html#amerge
# ffmpeg.org/ffmpeg.html#pan
# ffmpeg.org/pipermail/ffmpeg-devel/2012-January/119410.html

# Get audio files
ffmpeg -i SVF.mp4 SVF.wav
ffmpeg -i SAF.mp3 SAF.wav

# Merge audio streams
ffmpeg -i nelly.mp4 -f lavfi -i "
amovie=nelly.wav [a0];
amovie=pro.wav [a1];
[a0][a1] amerge, pan=2:c0=c0+c2:c1=c1+c3" \
-map v -map 1 -c:v copy -c:a libvo_aacenc nelly-good.mp4
