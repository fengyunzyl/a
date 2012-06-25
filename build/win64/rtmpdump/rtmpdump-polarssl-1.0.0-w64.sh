#!/bin/sh

# Install GCC core
wget dl.sf.net/tdm-gcc/gcc-4.6.1-tdm64-1-core.tar.lzma
tar xf gcc*

# Install GNU binutils
wget dl.sf.net/tdm-gcc/binutils-2.21.53-20110731-tdm64-1.tar.lzma
tar xf binutils*

# Install mingw64 runtime
wget dl.sf.net/tdm-gcc/mingw64-runtime-tdm64-gcc46-svn4483.tar.lzma
tar xf mingw64-runtime*

# Install Zlib
wget dfn.dl.sf.net/mingw-w64/zlib-1.2.5-bin-x64.zip
unzip -n zlib*
cd zlib
cp -r * /c/mingw32
cd -

# Install PolarSSL 1.0.0
wget polarssl.org/code/releases/polarssl-1.0.0-gpl.tgz
tar xf polarssl*
cd polarssl*
make CC=gcc APPS=
make DESTDIR=/mingw install
cd -

# Build RtmpDump
# mingw.org/wiki/IncludePathHOWTO
# gcc.gnu.org/onlinedocs/gcc/Environment-Variables.html
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
make SHARED= SYS=mingw CRYPTO=POLARSSL \
CPATH=/mingw/include LIBRARY_PATH=/mingw/lib
# Optional, build librtmp.dll
make SYS=mingw CRYPTO=POLARSSL
