#!/bin/sh
# Need this for v2.4-39-gdc1ddd3 and earlier

wget polarssl.org/download/polarssl-1.0.0-gpl.tgz
tar xf polarssl-1.0.0-gpl.tgz
cd polarssl-1.0.0
make \
  APPS= \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
