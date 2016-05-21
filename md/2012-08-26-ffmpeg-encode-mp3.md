---
layout: post
title: FFmpeg, encode mp3
tags: FFmpeg
---

~~~ bash
# FLV, AAC audio
ffmpeg -i in.flv -q 1 -map a out.mp3
# Apply max noclip gain
mp3gain -r -k -m 10 out.mp3

# FLV, MP3 audio
ffmpeg -i in.flv -c copy -map a out.mp3

# MP3 file
ffmpeg -i in.mp3 -c copy -map a out.mp3

# WAV source
ffmpeg -i in.wav -b:a 320k out.mp3

# Flac source
ffmpeg -i in.flac -b:a 320k out.mp3
~~~

<http://hydrogenaudio.org/forums/index.php?showtopic=10630>
