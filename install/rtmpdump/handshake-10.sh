#!/bin/sh
# RtmpDump with Handshake 10

# Install PolarSSL
wget polarssl.org/download/polarssl-1.1.4-gpl.tgz
tar xf polarssl-1.1.4-gpl.tgz
cd polarssl-1.1.4
make \
  APPS= \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install RtmpDump
wget m1.archiveorange.com/m/att/5hTZa/ArchiveOrange_VBYOyGhyRngLOtrtTAtaYPOcOgQa.zip
7z e ArchiveOrange_VBYOyGhyRngLOtrtTAtaYPOcOgQa.zip
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
git checkout -b handshake-10 603f
git am ../0001-Handshake-10.patch
make \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static
