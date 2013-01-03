#!/bin/bash
# Fix for live streams

answers ()
{
  # rtmp.c
  for aa in \
    y y y y y y y y y y \
    y y y y y y y y y y \
    y y y y y y y y y y \
    y y y y n n n n n y \
    n n y
  do
    echo $aa
  done

  # rtmp.h
  for aa in \
    y y y
  do
    echo $aa
  done

  # rtmp_sys.h
  for aa in \
    n y n n
  do
    echo $aa
  done

  # rtmpdump.c
  for aa in \
    n y n n n y
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

grepkill ()
{
  # search stderr, then kill
  while [ -d /proc/$! ]
  do
    if grep -q "$1" $2
    then
      kill %%
      > $2
      echo
    fi
    sleep 1
  done 2>/dev/null
}

./rtmpdump -a live/kiss -o a.flv -r rtmp://fms53.mediadirect.ro/live/kiss \
  -\# 2> >(tee kk) &

grepkill '#####################' kk
