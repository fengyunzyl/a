#!/bin/bash
# Create distribution!
gcc=i686-w64-mingw32-gcc
strip=i686-w64-mingw32-strip

cd rtmpdump
mkdir ds
read t_rtmpdump < <(stat -c%z rtmpdump.exe | xargs -0 date -d)
read v_rtmpdump < <(git describe --tags)
cp rtmpdump.exe rtmpgw.exe rtmpsrv.exe rtmpsuck.exe librtmp/librtmp.dll ds

# COMPRESS FILES
cd ds
$strip *
upx -9 *

# README
read v_gcc < <($gcc -dumpversion)

: '#include <polarssl/version.h>
POLARSSL_VERSION_STRING'
read v_polarssl < <($gcc -E -xc - <<< "$_" | tac | tr -d \")

: '#include <zlib.h>
ZLIB_VERSION'
read v_zlib < <($gcc -E -xc - <<< "$_" | tac | tr -d \")

cat > README.txt <<EOF
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
EOF

# ARCHIVE
7z a "rtmpdump-$v_rtmpdump.7z"
