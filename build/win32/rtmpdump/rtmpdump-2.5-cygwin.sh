#!/bin/sh
# Install Cygwin packages
./setup -nqs ftp://lug.mtu.edu/cygwin -P git,make,mingw64-i686-gcc-core,wget

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib*
cd zlib*
make install -f win32/Makefile.gcc PREFIX=$PREFIX

# Determine correct PolarSSL
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout handshake-10
v='0.14.3'
grep -r ciphersuite * && v='1.0.0'
grep -r havege_random * && v='1.1.3'
cd -

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-$v-gpl.tgz
tar xf polarssl*
cd polarssl*
# SYS_LDFLAGS=-lws2_32 is only needed for APPS, which we are not using.
make APPS=
make install DESTDIR=$DESTDIR
cd -

# Install RtmpDump
cd rtmpdump
# XLDFLAGS works with rtmpdump.exe and librtmp.dll
make SYS=mingw CRYPTO=POLARSSL SHARED= XLDFLAGS='-s -static' \
    VERSION=$(git describe --tags)
