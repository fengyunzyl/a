#!/bin/sh
# This install requires MSYS Base System.
mingw-get install msys-dvlpr
mingw-get install msys-libcrypt
mingw-get install msys-libminires
mingw-get install msys-libopenssl
mingw-get install msys-patch
mingw-get install msys-wget
mingw-get install msys-zlib

# Install openssh
wget mirror.esc7.net/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz
tar xf openssh*
cd openssh*

MSYSTEM=MSYS
PATH=/bin
# Update config scripts, need quotes
wget -O config.guess \
'git.savannah.gnu.org/gitweb?p=config.git;a=blob_plain;f=config.guess'
wget -O config.sub \
'git.savannah.gnu.org/gitweb?p=config.git;a=blob_plain;f=config.sub'
# diff -ru a b > openssh.patch
patch -p1 < ../openssh.patch
autoreconf
./configure
make install LIBS='-lcrypt -lz /lib/libcrypto.a /lib/libminires.a'
