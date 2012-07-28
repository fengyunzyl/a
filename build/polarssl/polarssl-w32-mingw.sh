#!/bin/sh
# Build PolarSSL!
# This install requires MSYS Base System.
# I prefer this over installing MinGW Developer Toolkit.

# Install dependencies
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
