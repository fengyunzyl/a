#!/bin/sh

# Install dependencies
mingw-get install msys-wget

# Install binutils
wget ftp.gnu.org/gnu/binutils/binutils-2.22.tar.bz2
tar xf binutils*
cd binutils*

PATH=/mingw/bin:/bin
cd bfd
./configure
make
cd -

cd libiberty
./configure
make
cd -

cd binutils
./configure
# lists.gnu.org/archive/html/bug-libtool/2012-03/msg00011
make strings.exe
