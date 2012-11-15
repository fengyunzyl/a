#!/bin/bash

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-1.0.0-gpl.tgz
tar xf polarssl-1.0.0-gpl.tgz
cd polarssl-1.0.0
make \
  APPS= \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install RtmpDump
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
git checkout e005
make \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static
