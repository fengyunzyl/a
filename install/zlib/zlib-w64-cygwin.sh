#!/bin/sh
# Install Zlib

wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib-1.2.7.tar.bz2
cd zlib-1.2.7
make install -f win32/Makefile.gcc \
  BINARY_PATH=/bin \
  INCLUDE_PATH=/include \
  LIBRARY_PATH=/lib \
  DESTDIR=/usr/x86_64-w64-mingw32/sys-root/mingw \
  PREFIX=x86_64-w64-mingw32-
