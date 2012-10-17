#!/bin/sh
# Install Cygwin packages
# make
# mingw64-x86_64-gcc-core
# wget
p=x86_64-w64-mingw32
alternatives \
	--install /usr/bin/gcc.exe gcc /usr/bin/$p-gcc.exe 0 \
	--slave /usr/bin/ar.exe ar /usr/bin/$p-ar.exe \
	--slave /usr/bin/strip.exe strip /usr/bin/$p-strip.exe \
	--slave /usr/bin/windres.exe windres /usr/bin/$p-windres.exe \
	--slave /mingw mingw /usr/$p/sys-root/mingw

# Install Zlib
wget prdownloads.sf.net/libpng/zlib-1.2.6.tar.bz2
tar xf zlib*
cd zlib*
make install -f win32/Makefile.gcc \
	BINARY_PATH=/mingw/bin \
	INCLUDE_PATH=/mingw/include \
	LIBRARY_PATH=/mingw/libcharset
