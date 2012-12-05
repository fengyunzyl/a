#!/bin/bash
# Fix for live streams

answers ()
{
  # rtmp.c
  for a in \
    n n n n n n n n n n \
    n n n n n n n y n n \
    n n n n n n n n n n \
    n n n n n n n n n n \
    n n n
    do
      echo $a
    done
}

git reset --hard origin
git apply -p0 ../Patch.diff
git add -p librtmp/rtmp.c < <(answers)
git commit -m live
git reset --hard

make rtmpdump \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static || exit

timeout 2 ./rtmpdump \
  -o a.flv \
  -r rtmp://d.cdn.msnbclive.eu/edge/cnbc_live \
  -W http://msnbclive.eu/player.swf  
