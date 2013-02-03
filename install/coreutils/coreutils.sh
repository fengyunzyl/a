#!/bin/sh
# http://github.com/svnpenn/a/tree/d826/build/win32/coreutils
# http://cross-lfs.org/view/svn/mips64-64/temp-system/coreutils.html

wget ftp.gnu.org/gnu/coreutils/coreutils-8.20.tar.xz
tar xf coreutils-8.20.tar.xz
cd coreutils-8.20
# configure: error: could not determine how to read list of mounted file systems
git apply ../a.diff
./configure --host i686-w64-mingw32
# configure:CONFIG_INCLUDE=lib/config.h
cp lib/config.h /usr/i686-w64-mingw32/sys-root/mingw/include
make

# i686-w64-mingw32-gcc -std=gnu99 -g -O2    src/make-prime-list.c
# src/make-prime-list 5000 > src/primes.h-t
