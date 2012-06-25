#!/bin/sh

# Install dependencies
mingw-get install msys-wget

# Install make
wget ftp.gnu.org/gnu/make/make-3.82.tar.bz2
tar xf make*
cd make*

PATH=/mingw/bin:/bin
cp config.h.W32 config.h
./configure
make
