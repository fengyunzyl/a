#!/bin/sh
# Install Cygwin packages
# make
# mingw64-x86_64-gcc-core
# wget
p=x86_64-w64-mingw32
alternatives \
	--install /usr/bin/gcc.exe gcc /usr/bin/$p-gcc.exe 0

# Install libiconv
wget ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
tar xf libiconv*
cd libiconv*
./configure
make
# Creating library file: .libs/libcharset.dll.a
# libtool: link: false cru .libs/libcharset.a  localcharset.o relocatable.o
# Makefile:59: recipe for target `libcharset.la' failed
