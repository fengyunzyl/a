#!/bin/sh
# Install Cygwin packages
# make
# mingw64-i686-gcc
host=i686-w64-mingw32
prefix=/usr/i686-w64-mingw32/sys-root/mingw

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib*
cd zlib*
make install -f win32/Makefile.gcc \
	BINARY_PATH=$prefix/bin \
	INCLUDE_PATH=$prefix/include \
	LIBRARY_PATH=$prefix/lib \
	PREFIX=$host-
