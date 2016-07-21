#!/bin/dash -e
host=x86_64-w64-mingw32
prefix=/usr/$host/sys-root/mingw
git clone --depth 1 git://github.com/mstorsjo/fdk-aac
cd fdk-aac
./autogen.sh
./configure --host=$host --prefix=$prefix
make --jobs 5
make install
