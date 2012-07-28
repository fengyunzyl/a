#!/bin/bash

# Determine correct PolarSSL
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
v=0.14.3
grep -r ciphersuite . && v=1.0.0 && grep -r havege_random . && v=1.1.3
cd -

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-$v-gpl.tgz
tar xf polarssl*
cd polarssl*
make APPS= AR=i686-w64-mingw32-ar CC=i686-w64-mingw32-gcc
make install DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib*
cd zlib*
make install -f win32/Makefile.gcc BINARY_PATH=/bin \
	DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw INCLUDE_PATH=/include \
	LIBRARY_PATH=/lib PREFIX=i686-w64-mingw32-
cd -

# Install RtmpDump
cd rtmpdump
git tag v2.4 c28f1ba
# Build
read < <(git describe --tags)

make CROSS_COMPILE=i686-w64-mingw32- CRYPTO=POLARSSL SYS=mingw SHARED= \
  XLDFLAGS=-static VERSION=$REPLY

# Build librtmp.dll
make CROSS_COMPILE=i686-w64-mingw32- CRYPTO=POLARSSL SYS=mingw
