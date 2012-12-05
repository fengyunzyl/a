#!/bin/bash
# "strip" and "upx" make smaller binaries without increasing archive size

# Install Zlib
wget zlib.net/zlib-1.2.7.tar.bz2
tar xf zlib-1.2.7.tar.bz2
cd zlib-1.2.7
make install -f win32/Makefile.gcc \
  BINARY_PATH=/bin \
  INCLUDE_PATH=/include \
  LIBRARY_PATH=/lib \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw \
  PREFIX=i686-w64-mingw32- \
  CFLAGS=-Os
cd -

# Install PolarSSL
wget polarssl.org/download/polarssl-1.2.0-gpl.tgz
tar xf polarssl-1.2.0-gpl.tgz
cd polarssl-1.2.0
make lib \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc \
  OFLAGS=-Os
make install \
  DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# Install RtmpDump
git clone git://github.com/svnpenn/rtmpdump.git
cd rtmpdump
git checkout pu
read < <(git describe --tags)
make install \
  SYS=mingw \
  CRYPTO=POLARSSL \
  CROSS_COMPILE=i686-w64-mingw32- \
  SHARED= \
  XLDFLAGS=-static \
  prefix=$PWD \
  VERSION=$REPLY \
  OPT=-Os

# Compress files
fs=(bin/rtmpdump.exe sbin/{rtmpgw.exe,rtmpsrv.exe,rtmpsuck.exe})
i686-w64-mingw32-strip ${fs[@]}
upx -9 ${fs[@]}

# Readme
read t_rtmpdump < <(stat -c%z bin/rtmpdump.exe | xargs -0 date -d)
read v_rtmpdump < <(git describe --tags)
CC=i686-w64-mingw32-gcc
read v_gcc < <($CC -dumpversion)

vr ()
{
  echo "#include <$2>
  $1" > a.c
  read $1 < <($CC -E a.c | tac | tr -d \")
}

vr POLARSSL_VERSION_STRING polarssl/version.h
vr ZLIB_VERSION zlib.h

echo "
This is a RtmpDump Win32 static build by Steven Penny.

Steven’s Home Page: http://svnpenn.github.com

Built on $t_rtmpdump

RtmpDump version $v_rtmpdump

The source code for this RtmpDump build can be found at
  http://github.com/svnpenn/rtmpdump

This version of RtmpDump was built on
  Windows 7 Ultimate Service Pack 1
  http://windows.microsoft.com/en-us/windows7/products/home

The toolchain used to compile this RtmpDump was
  MinGW-w64: http://mingw-w64.sourceforge.net

The GCC version used to compile this RtmpDump was
  GCC $v_gcc: http://gcc.gnu.org

The external libraries compiled into this RtmpDump are
  Zlib $v_zlib http://zlib.net
  PolarSSL $v_polarssl http://polarssl.org
" > README.txt
u2d README.txt

# Archive
tar acf rtmpdump-$v_rtmpdump.tar.gz \
  README.txt \
  bin \
  man \
  sbin
