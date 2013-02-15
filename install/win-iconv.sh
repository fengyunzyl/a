#!/bin/sh
# Iconv that is not bullshit

wget win-iconv.googlecode.com/files/win-iconv-0.0.6.tar.bz2
tar xf win-iconv-0.0.6.tar.bz2
cd win-iconv-0.0.6
make install \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc \
  RANLIB=i686-w64-mingw32-ranlib \
  prefix=/usr/i686-w64-mingw32/sys-root/mingw
