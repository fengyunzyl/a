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
git clean -fdx
autoreconf -iv
./configure \
  --host=$HOST \
  --prefix=$PREFIX
make -j5 install
# rm $PREFIX/lib/libfdk-aac.dll.a
cd -

# pthreads-w32
# wget ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-9-1-release.tar.gz
# tar xf pthreads-w32-2-9-1-release.tar.gz
# cd pthreads-w32-2-9-1-release
# make GC-static CROSS=$HOST-
# rm $PREFIX/lib/libpthread.{a,dll.a}
# cp libpthreadGC2.a $PREFIX/lib
# cp pthread.h sched.h semaphore.h $PREFIX/include
# cd -

# x264
git clone --depth 1 git://git.videolan.org/x264.git
cd x264
git clean -fdx
./configure \
  --enable-static \
  --cross-prefix=$HOST- \
  --prefix=$PREFIX \
  --enable-win32thread
make -j5 install
cd -

# ffmpeg
# --enable-pthreads
# --extra-cflags=-DPTW32_STATIC_LIB
git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
git clean -fdx
./configure \
  --enable-gpl \
  --enable-libx264 \
  --enable-nonfree \
  --enable-libfdk-aac \
  --arch=x86 \
  --target-os=mingw32 \
  --logfile=/dev/stdout \
  --host-cc=$HOST-gcc \
  --cross-prefix=$HOST- \
  --extra-ldflags=-static
make -j5

# test
set 'Breaking Bad - S03E12 - Half Measures.mp4'
./ffmpeg -i "c:/steven/videos/breaking bad/season 3/$1" -t 10 -y outfile.mp4
