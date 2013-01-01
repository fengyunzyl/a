#!/bin/sh

wget ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
tar xf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure \
  --disable-shared \
  --enable-static \
  --host i686-w64-mingw32 \
  --prefix /usr/i686-w64-mingw32/sys-root/mingw
make install-lib \
  AR=i686-w64-mingw32-ar
