#!/bin/dash -e
host=x86_64-w64-mingw32
prefix=/usr/$host/sys-root/mingw
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --enable-static --enable-win32thread --cross-prefix=$host- \
--prefix=$prefix
make --jobs 5
make install
