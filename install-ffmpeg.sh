# FFmpeg with libfdk_aac
HOST=i686-w64-mingw32
PREFIX=/usr/i686-w64-mingw32/sys-root/mingw
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
./configure --enable-static --enable-win32thread --cross-prefix=$HOST- \
  --prefix=$PREFIX
make -j5 install
cd -

# zlib
wget zlib.net/zlib-1.2.8.tar.xz
tar xf zlib-1.2.8.tar.xz
cd zlib-1.2.8
make -f win32/Makefile.gcc PREFIX=$HOST- DESTDIR=$PREFIX BINARY_PATH=/bin \
  INCLUDE_PATH=/include LIBRARY_PATH=/lib install
cd -

# ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-libx264 --enable-nonfree --enable-libfdk-aac \
  --arch=x86 --target-os=mingw32 --logfile=/dev/stdout --extra-ldflags=-static \
  --cross-prefix=$HOST- --host-cc=$HOST-gcc
make -j5 install
