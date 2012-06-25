#!/bin/sh
# This installs Git without Perl or TclTk
# git-send-email and gitk wont work.
# git will rely on MinGW's OpenSSH.

# Install dependencies
mingw-get install libiconv
mingw-get install libz # git status
mingw-get install msys-wget

mingw-get install gmp

# Install Git
wget github.com/git/git/tarball/master
tar xf git-git*
cd git-git*
# Smaller without "THIS_IS_MSYSGIT".
make daemon.o NO_OPENSSL=1 NO_GETTEXT=1
