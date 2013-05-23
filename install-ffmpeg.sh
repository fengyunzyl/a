# Cygwin FFmpeg with libfdk_aac
setup -nqP libtool,yasm
HOST=i686-w64-mingw32
PREFIX=/mingw32/i686-w64-mingw32

# GCC
wget downloads.sf.net/mingw-w64/i686-w64-mingw32-gcc-4.8.0-cygwin_rubenvb.tar.xz
tar xf i686-w64-mingw32-gcc-4.8.0-cygwin_rubenvb.tar.xz
mv mingw32 /

# fdk_aac
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -iv
./configure \
  --host=$HOST \
  --prefix=$PREFIX
make -j5 install
cd -

# x264
git clone --depth 1 git://git.videolan.org/x264.git
cd x264
./configure \
  --enable-static \
  --enable-win32thread \
  --cross-prefix=$HOST- \
  --prefix=$PREFIX
make -j5 install
cd -

# zlib
wget zlib.net/zlib-1.2.8.tar.xz
tar xf zlib-1.2.8.tar.xz
cd zlib-1.2.8
make -f win32/Makefile.gcc install \
  PREFIX=$HOST- \
  DESTDIR=$PREFIX \
  BINARY_PATH=/bin \
  INCLUDE_PATH=/include \
  LIBRARY_PATH=/lib
cd -

# ffmpeg
git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure \
  --enable-gpl \
  --enable-libx264 \
  --enable-nonfree \
  --enable-libfdk-aac \
  --arch=x86 \
  --target-os=mingw32 \
  --logfile=/dev/stdout \
  --extra-ldflags=-static \
  --cross-prefix=$HOST- \
  --host-cc=$HOST-gcc
make -j5 install
