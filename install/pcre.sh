#!/bin/sh
set i686-w64-mingw32
set $1 /usr/$1/sys-root/mingw

# install PCRE
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2
tar xf pcre-8.31.tar.bz2
cd pcre-8.31
./configure --disable-cpp --disable-shared --host $1 --prefix $2
make install
cd -

# install regex.h
# http://pcre.org/readme.txt
# http://kemovitra.blogspot.com/2009/07/mingw-porting-gnu-regex-to-windows.html
cd $2/include
cp pcreposix.h regex.h
cd -
