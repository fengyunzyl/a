#!/bin/sh
# Install PolarSSL

wget polarssl.org/download/polarssl-1.2.0-gpl.tgz
tar xf polarssl-1.2.0-gpl.tgz
cd polarssl-1.2.0
make lib \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
