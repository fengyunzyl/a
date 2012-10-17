#!/bin/sh
# Build PCRE

wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2
tar xf pcre*
cd pcre*
: i686-w64-mingw32
./configure --disable-cpp --disable-shared --host=$_ \
  --prefix=/usr/$_/sys-root/mingw
make install
