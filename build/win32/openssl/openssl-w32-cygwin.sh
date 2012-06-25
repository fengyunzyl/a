#!/bin/sh
# blogcompiler.com/2011/12/21/openssl-for-windows
# Install Cygwin packages
# automake
# make
# mingw64-i686-gcc-core
host=i686-w64-mingw32
prefix=/usr/i686-w64-mingw32/sys-root/mingw

# Install OpenSSL
wget openssl.org/source/openssl-1.0.1c.tar.gz
tar xf openssl*
cd openssl*
./Configure mingw64 no-asm shared \
	--prefix=/usr/i686-w64-mingw32/sys-root/mingw \
	--cross-compile-prefix=i686-w64-mingw32-
make





tar xf openssl*
cd openssl*
./Configure mingw64 no-asm \
	--cross-compile-prefix=i686-w64-mingw32- \
	--prefix=/usr/i686-w64-mingw32/sys-root/mingw
make install
cd -









