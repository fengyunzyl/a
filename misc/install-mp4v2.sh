#!/bin/sh
sage install automake git libtool make mingw64-i686-gcc-g++
git clone git://github.com/svnpenn/mp4v2
cd mp4v2
autoreconf --install --verbose
./configure --host i686-w64-mingw32
make --jobs 5 LDFLAGS=-all-static \
  DEFS='-DMP4V2_USE_STATIC_LIB -D__STDC_CONSTANT_MACROS'
