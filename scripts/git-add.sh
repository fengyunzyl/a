#!/bin/bash
# Fix for live streams

answers ()
{
  # rtmp.c
  for aa in \
    n n y n y n n n n n \
    n n n n n n n n n n \
    n y y n n n n n y Y \
    n n n n n n n n n n \
    n n y
  do
    echo $aa
  done

  # rtmp.h
  for aa in \
    n n y
  do
    echo $aa
  done

  # rtmpdump.c
  for aa in \
    n y n n n y
  do
    echo $aa
  done

  # rtmp_sys.h
  for aa in \
    n n n y
  do
    echo $aa
  done
}

git reset --hard origin~1
git apply -p0 ../Patch.diff
git add -p \
  librtmp/rtmp.c \
  librtmp/rtmp.h \
  librtmp/rtmp_sys.h \
  rtmpdump.c \
  < <(answers)
git commit -m foo
git reset --hard

make rtmpdump \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static || exit

timeout 14 ./rtmpdump \
  -o a.flv \
  -r rtmp://s31.webvideocore.net/live/ \
  -y 7zlyq17szhc0o0wwsg4o
