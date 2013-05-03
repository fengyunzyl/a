# Cygwin FFmpeg with libfdk_aac
setup -nqP libtool
setup -nqP mingw64-i686-gcc-g++
setup -nqP yasm

# libfdk_aac
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure \
  --host i686-w64-mingw32 \
  --prefix /usr/i686-w64-mingw32/sys-root/mingw
make -j5 install
cd -

# install ffmpeg
# --enable-libx264
git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure \
  --enable-libfdk-aac \
  --arch=x86 \
  --target-os=mingw32 \
  --cross-prefix=i686-w64-mingw32- \
  --disable-indevs \
  --disable-doc \
  --extra-ldflags=-static
make -j5

# test
set $HOMEDRIVE/$USERNAME/music/autechre/amber-flac/Amber-007-Autechre-Nine.flac
./ffmpeg -i $1 -c:a libfdk_aac -map a outfile.m4a
