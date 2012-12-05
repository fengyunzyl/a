#!/bin/sh
# Install Cygwin packages
# m4
# make
# mingw64-x86_64-gcc-core
# wget
t=x86_64-w64-mingw32

# Install gmp
wget ftp.gnu.org/gnu/gmp/gmp-5.0.5.tar.xz
tar xf gmp*
cd gmp*
./configure --host=$t --prefix=/usr/$t/sys-root/mingw
make install
cd -

# Install nettle
wget ftp.lysator.liu.se/pub/security/lsh/nettle-2.4.tar.gz
tar xf nettle*
cd nettle*
./configure --host=$t --prefix=/usr/$t/sys-root/mingw
make install AR=$t-ar
