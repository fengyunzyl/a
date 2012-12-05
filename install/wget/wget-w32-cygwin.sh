#!/bin/sh
# Install Cygwin packages
# automake
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

# Install OpenSSL
wget openssl.org/source/openssl-1.0.1c.tar.gz
tar xf openssl*
cd openssl*
./Configure --cross-compile-prefix=$host- --prefix=$prefix mingw64 no-asm
make install
cd -

# Install Wget
wget ftp.gnu.org/gnu/wget/wget-1.13.4.tar.xz
tar xf wget*
cd wget*
./configure \
	--host=$host \
	--prefix=$prefix \
	--disable-ipv6 \
	--with-ssl=openssl \
	CFLAGS=-Os
make install
cd -
# strip *
# upx -9 *
# wget github.com/git/git/tarball/master
