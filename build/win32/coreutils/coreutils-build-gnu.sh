#!/bin/sh
# mingw.org/wiki/HOWTO_Create_an_MSYS_Build_Environment

# Install dependencies
mingw-get install msys-dvlpr
mingw-get install msys-libcrypt
mingw-get install msys-wget

# Install coreutils
wget ftp.gnu.org/gnu/coreutils/coreutils-8.16.tar.xz
tar xf coreutils*
cd coreutils*

MSYSTEM=MSYS
PATH=/bin
# 4 minutes
./configure
# sourceforge.net/mailarchive/message.php?msg_id=28609690
make DEFS=-DEILSEQ=138
#