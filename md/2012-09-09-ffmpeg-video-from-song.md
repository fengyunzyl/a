---
layout: post
title: FFmpeg, Video from song and image
tags: FFmpeg
---

~~~ bash
# trunc rounds towards zero

# standard
ffmpeg -loop 1 -i image.jpg -i audio.mp3 -c:v libx264 -vprofile main \
  -vf scale=trunc(oh*a/2)*2:480 -c:a copy -shortest out.flv

# wide
ffmpeg -loop 1 -i image.jpg -i audio.mp3 -c:v libx264 -vprofile main \
  -vf scale=854:trunc(ow/a/2)*2 -c:a copy -shortest out.flv

# lossless
# need to scale to 720 to trigger 192 kbps audio on youtube
# webm, flv, mp4 dont support flac
ffmpeg -loop 1 -i b.jpg -i a.flac -vf scale=-1:720 -c:a copy -shortest \
  -x264opts crf=0 a.mkv
~~~

### Links
- <http://ffmpeg.org/pipermail/ffmpeg-user/2011-October/002629.html>
- <http://ffmpeg.org/pipermail/ffmpeg-user/2012-January/004312.html>
- <http://stackoverflow.com/q/14/difference-between-math-floor-and-math-truncat>
- <http://wikipedia.org/wiki/YouTube#Quality_and_codecs>
