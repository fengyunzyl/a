#!/bin/sh
# Install PolarSSL

wget polarssl.org/code/releases/polarssl-1.2.0-gpl.tgz
tar xf polarssl-1.2.0-gpl.tgz
cd polarssl-1.2.0
make lib AR=i686-w64-mingw32-ar CC=i686-w64-mingw32-gcc OFLAGS=-Os
make install DESTDIR=/usr/i686-w64-mingw32/sys-root/mingw
