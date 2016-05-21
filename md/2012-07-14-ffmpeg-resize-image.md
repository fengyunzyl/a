---
layout: post
title: FFmpeg, Resize image
tags: Windows
---

### Lanczos

~~~ bash
ffmpeg -i in.jpg -qmax 1 -vf scale=-1:360 -sws_flags lanczos out-360.jpg
~~~

### Bicubic

~~~ bash
ffmpeg -i in.jpg -qmax 1 -vf scale=-1:360 -sws_flags bicubic out-360.jpg
# or simply
ffmpeg -i in.jpg -qmax 1 -vf scale=-1:360 out-360.jpg
# larger
ffmpeg -i in.jpg -qmax 1 -vf scale=-1:480 out-480.jpg
~~~

### Notes
Lanczos is better quality.

### Links
* <http://git.videolan.org/?p=ffmpeg.git;a=blob;f=libswscale/options.c>
* <http://linux-tipps.blogspot.com/2010/11/which-software-scaler-looks-best.html>
* <http://www.mr.web.id/computing/linux/common-use-of-ffmpeg>
* <http://stackoverflow.com/questions/7591326/fast-image-downscaling-in-c-c>
* <http://wieser-web.de/MPlayer/sws1>
