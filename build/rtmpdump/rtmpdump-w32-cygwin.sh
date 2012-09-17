#!/bin/bash
# This is to build MY RtmpDump. The official one at http://rtmpdump.mplayerhq.hu
# at this point is terribly out of date. They are still using PolarSSL 1.0.0 and
# havent committed the patch for PolarSSL 1.1.1 in over 6 months. I have also
# since been moderated on the mailing list, so yeah, I am dropping support for
# building "official" RtmpDump.

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-1.1.4-gpl.tgz
tar xf polarssl-1.1.4-gpl.tgz
cd polarssl-1.1.4
make APPS= AR=i686-w64-mingw32-ar CC=i686-w64-mingw32-gcc
make install DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib-1.2.7.tar.bz2
cd zlib-1.2.7
make install -f win32/Makefile.gcc BINARY_PATH=/bin \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw INCLUDE_PATH=/include \
  LIBRARY_PATH=/lib PREFIX=i686-w64-mingw32-
cd -

# Install RtmpDump
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git tag v2.4 c28f1ba
read < <(git describe --tags)
make CROSS_COMPILE=i686-w64-mingw32- CRYPTO=POLARSSL SYS=mingw SHARED= \
  XLDFLAGS=-static VERSION=$REPLY

# Build librtmp.dll
make CROSS_COMPILE=i686-w64-mingw32- CRYPTO=POLARSSL SYS=mingw
