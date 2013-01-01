#!/bin/sh

# iconv that is not bullshit
wget win-iconv.googlecode.com/files/win-iconv-0.0.6.tar.bz2
tar xf win-iconv-0.0.6.tar.bz2
cd win-iconv-0.0.6
make install \
  AR=i686-w64-mingw32-ar \
  CC=i686-w64-mingw32-gcc \
  RANLIB=i686-w64-mingw32-ranlib \
  prefix=/usr/i686-w64-mingw32/sys-root/mingw
cd -

# install fatsort
wget downloads.sf.net/fatsort/fatsort-0.9.17.269.tar.gz
tar xf fatsort-0.9.17.269.tar.gz
cd fatsort-0.9.17.269
# patch
wget raw.github.com/svnpenn/a/master/install/fatsort/fatsort.diff
git apply fatsort.diff
make \
  CC=i686-w64-mingw32-gcc \
  LD=i686-w64-mingw32-gcc \
  LDFLAGS='-liconv -static'
