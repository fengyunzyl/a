#!/bin/sh
# Install dependencies
mingw-get install libz
mingw-get install msys-wget

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
make CC=gcc APPS=
make DESTDIR=/mingw install
cd -

# Install RtmpDump
cd rtmpdump
git tag 'v2.4' 'c28f1ba'
# Build
make SYS=mingw CRYPTO=POLARSSL SHARED= XLDFLAGS=-static \
	VERSION=$(git describe --tags)
# Build librtmp.dll
make SYS=mingw CRYPTO=POLARSSL