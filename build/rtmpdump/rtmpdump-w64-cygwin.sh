#!/bin/sh
# Install Cygwin packages
# git
# make
# mingw64-x86_64-gcc-core
# wget
p=x86_64-w64-mingw32
alternatives \
	--install /usr/bin/gcc.exe gcc /usr/bin/$p-gcc.exe 40 \
	--slave /usr/bin/cc.exe cc /usr/bin/$p-gcc.exe \
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
	LIBRARY_PATH=/mingw/lib

# Install PolarSSL
wget polarssl.org/code/releases/polarssl-1.0.0-gpl.tgz
tar xf polarssl*
cd polarssl*
make APPS=
make DESTDIR=/mingw install
cd -

# Install RtmpDump
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
make CRYPTO=POLARSSL SHARED= SYS=mingw
