# build RtmpDump

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib-1.2.7.tar.bz2
cd zlib-1.2.7
make -f win32/Makefile.gcc install \
  BINARY_PATH=/bin \
  INCLUDE_PATH=/include \
  LIBRARY_PATH=/lib \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw \
  PREFIX=i686-w64-mingw32-
cd -

# Install PolarSSL
wget polarssl.org/download/polarssl-1.2.7-gpl.tgz
tar xf polarssl-1.2.7-gpl.tgz
cd polarssl-1.2.7
make lib \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install RtmpDump
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout pu
make install \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static \
  VERSION=$(git describe --tags)
