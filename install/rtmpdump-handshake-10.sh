#!/bin/sh
# RtmpDump with Handshake 10
# Must use bitbucket because of GitHub DMCA
# http://stream-recorder.com/forum/thedailyshow-com-rtmpe-t14437.html

# Create dist
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout 603ff20
read < <(git describe --tags)
7z a " h10-$REPLY.7z" ../handshake-10.patch

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
wget bitbucket.org/svnpenn/rtmpdump/downloads/h10-v2.4-34-g603ff20.7z
7z e h10-v2.4-34-g603ff20.7z
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout -b handshake-10 603ff20
git am ../handshake-10.patch
make \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static
