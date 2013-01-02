#!/bin/bash
# Fix for live streams

answers ()
{
  # rtmp.c
  for a in \
    y y y y y y y y y y \
    y y y y y y y y y y \
    y y y y y y y y y y \
    y y y y y y y y y y \
    y y y
  do
    echo $a
  done
}

git reset --hard origin~1
git apply -p0 ../Patch.diff
# git add -p librtmp/rtmp.c < <(answers)
git add -p < <(answers)
git commit -m foo
git reset --hard

make rtmpdump \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static || exit

./rtmpdump -r rtmp://s31.webvideocore.net/live/ -y 7zlyq17szhc0o0wwsg4o -o a.flv
