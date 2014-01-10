# FFmpeg with libfdk_aac
HOST=i686-w64-mingw32
PREFIX=/usr/i686-w64-mingw32/sys-root/mingw
# libtool           autoreconf
# mingw64-i686-gcc  need g++ for fdk-aac
# yasm              need for x264
setup-x86 -nqP libtool,mingw64-i686-gcc,yasm

# fdk-aac
git clone --depth 1 git://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -i
./configure --host=$HOST --prefix=$PREFIX
make -j5 install
cd -

# x264
git clone --depth 1 git://git.videolan.org/x264
cd x264
# --enable-static       library is built by default but not installed
# --enable-win32thread  avoid installing pthread
./configure --enable-static --enable-win32thread --cross-prefix=$HOST- \
  --prefix=$PREFIX
make -j5 install
cd -

# zlib  need for PNG
wget zlib.net/zlib-1.2.8.tar.xz
tar xf zlib-1.2.8.tar.xz
cd zlib-1.2.8
# INCLUDE_PATH  need for zlib.h
# LIBRARY_PATH  need for libz.a
make -f win32/Makefile.gcc PREFIX=$HOST- DESTDIR=$PREFIX \
  INCLUDE_PATH=/include LIBRARY_PATH=/lib install
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
./configure --enable-gpl --enable-libx264 --enable-nonfree --enable-libfdk-aac \
  --arch=x86 --target-os=mingw32 --logfile=/dev/stdout --extra-ldflags=-static \
  --cross-prefix=$HOST- --disable-doc
make -j5 install
