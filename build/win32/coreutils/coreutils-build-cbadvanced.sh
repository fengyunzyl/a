#!/bin/sh
# mingw.org/wiki/HOWTO_Create_an_MSYS_Build_Environment

# Install dependencies
mingw-get install msys-dvlpr

# Install coreutils
# Download and extract
# prdownloads.sf.net/cbadvanced/msys-coreutils-8-10-1-src.7z
# sourceforge.net/projects/cbadvanced/files/Sources

MSYSTEM=MSYS
PATH=/bin
./build.sh


# cat.c:511: undefined reference to `_rpl_getpagesize'
# lug.mtu.edu/cygwin/release/coreutils/coreutils-8.10-1-src.tar.bz2

# diff -ru a b > coreutils.diff
# old.nabble.com/Compile-Coreutils-on-msys%EF%BC%9F-td30473032.html
# old.nabble.com/Problems-with-tclsh-executing-scripts.-td29870519.html


### xz/9c:      79 seconds / 53.400% smaller




















