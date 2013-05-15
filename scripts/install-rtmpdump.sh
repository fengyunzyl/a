# build RtmpDump
# Toolchains targetting Win32/Personal Builds/rubenvb/gcc-4.8-release

# Install PolarSSL
wget polarssl.org/download/polarssl-1.2.7-gpl.tgz
tar xf polarssl-1.2.7-gpl.tgz
cd polarssl-1.2.7
mingw32-make lib CC=gcc
mingw32-make install DESTDIR=/mingw32/i686-w64-mingw32
cd -

# Install RtmpDump
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout pu
mingw32-make \
  SYS=mingw \
  CRYPTO=POLARSSL \
  SHARED= \
  XLDFLAGS=-static \
  VERSION=`git describe --tags`
make install
