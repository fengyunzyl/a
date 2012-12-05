#!/bin/sh
# Install Cygwin packages
# automake
# make
# mingw64-x86_64-gcc-core
host=x86_64-w64-mingw32
prefix=/usr/x86_64-w64-mingw32/sys-root/mingw

# Install gmp
# wget ftp.gnu.org/gnu/gmp/gmp-5.0.5.tar.xz
tar xf gmp*
cd gmp*
./configure --host=$host --prefix=$prefix
make install
cd -

# Install nettle
# wget ftp.lysator.liu.se/pub/security/lsh/nettle-2.4.tar.gz
tar xf nettle*
cd nettle*
./configure --host=$host --prefix=$prefix
make install AR=$host-ar
cd -

# Install GnuTLS
# wget ftp.gnu.org/gnu/gnutls/gnutls-3.0.12.tar.xz
tar xf gnutls*
cd gnutls*
./configure \
	--host=$host \
	--prefix=$prefix \
	--disable-hardware-acceleration \
	--disable-shared
make install
cd -

# Install Wget
# wget ftp.gnu.org/gnu/wget/wget-1.13.4.tar.xz
tar xf wget*
cd wget*
./configure --host=$host --prefix=$prefix --disable-ipv6
make install
cd -
