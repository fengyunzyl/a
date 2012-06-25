#!/bin/sh

# Install dependencies
mingw-get install msys-libbz2
mingw-get install msys-wget

# Install slang
wget ftp://space.mit.edu/pub/davis/slang/v2.1/slang-2.1.4.tar.bz2
tar xf slang*
cd slang*

./configure


mkfiles/build.sh WIN32 MINGW32
mkfiles/build.sh WIN32 MINGW32 DLL


make



# sldisply.c:53:25: fatal error: sys/ioctl.h: No such file or directory


