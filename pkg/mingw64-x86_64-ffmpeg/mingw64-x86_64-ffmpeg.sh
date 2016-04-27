#!/bin/sh
host=x86_64-w64-mingw32
prefix=/usr/$host/sys-root/mingw
# automake > autoreconf > autogen.sh
# diffutils > cmp > configure
# libtool > autoreconf > autogen.sh
# make > make
# mingw64-x86_64-gcc-g++ > x86_64-w64-mingw32-g++
# yasm > x264
sage install automake diffutils libtool make mingw64-x86_64-gcc-g++ yasm
sage install --nodeps git

# fdk-aac
git clone --depth 1 git://github.com/mstorsjo/fdk-aac
cd fdk-aac
./autogen.sh
./configure --host=$host --prefix=$prefix
make -j5 install
cd -

# x264
git clone --depth 1 git://git.videolan.org/x264
cd x264
# --enable-static       library is built by default but not installed
# --enable-win32thread  avoid installing pthread
./configure --enable-static --enable-win32thread --cross-prefix=$host- \
--prefix=$prefix
make -j5 install
cd -

# ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
# --arch               must specify target arch when cross-compiling
# --disable-doc        documentation is built by default
# --enable-gpl         libx264 is gpl
# --enable-libfdk-aac  disabled by default
# --enable-libx264     disabled by default
# --enable-nonfree     libfdk_aac is incompatible with the gpl
# --extra-ldflags      default is shared build
# --logfile            verbose
# --target-os          must specify OS when cross-compiling
./configure --enable-gpl --disable-doc --enable-libx264 --enable-nonfree \
--enable-libfdk-aac --arch=x86_64 --target-os=mingw32 --logfile=/dev/stdout \
--extra-ldflags=-static --cross-prefix=$host-
make -j5 install
