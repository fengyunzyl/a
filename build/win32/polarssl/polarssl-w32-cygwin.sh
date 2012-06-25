#!/bin/sh
HOST=i686-w64-mingw32

# Install Cygwin packages
./setup -nqs ftp://lug.mtu.edu/cygwin -P make,mingw64-i686-gcc-core,wget

# Determine correct PolarSSL
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
v='0.14.3'
grep -r ciphersuite * && v='1.0.0'
grep -r havege_random * && v='1.1.3'
cd -

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-$v-gpl.tgz
tar xf polarssl*
cd polarssl*
# SYS_LDFLAGS=-lws2_32 is only needed for APPS, which we are not using.
make APPS= AR="$HOST-ar" CC="$HOST-gcc"
make install DESTDIR="/usr/$HOST/sys-root/mingw"
