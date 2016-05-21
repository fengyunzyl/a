---
layout: post
title: FFmpeg, Screencast Windows
tags: Windows
---

Also known as, desktop capture, desktop recording, screen capture, screen
recording.

### Setup

* Download [**FFmpeg**](http://ffmpeg.zeranoe.com/builds)

  Either 64-bit or 32-bit should work.

* Install [**screen-capture-recorder-to-video-windows-free**](https://github.com/rdp/screen-capture-recorder-to-video-windows-free)
  
  The actual downloads are at sourceforge, which is linked in the README. I
  found the README to be helpful. The installer should automatically install
  *Microsoft Visual C++ Redistributable* as well, if needed.

### Use

    ffmpeg -f dshow -i video=screen-capture-recorder -r 24000/1001 -q 1 out.avi

### Links
[superuser.com/q/81284/can-ffmpeg-capture-from-the-screen-in-windows](http://superuser.com/q/81284)
