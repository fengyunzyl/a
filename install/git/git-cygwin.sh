#!/bin/sh
# If we use gcc4-core, git will rely on cygwin dll. If we were to install git
# via setup.exe, it would be the same thing. So this is okay.

# Install Cygwin packages
# gcc4-core
# libiconv
# make
# wget
# zlib

# Install Git
wget github.com/git/git/tarball/master
tar xf git-git*
cd git-git*
make install prefix=/c/git \
	NO_CURL=1 NO_GETTEXT=1 NO_OPENSSL=1 NO_PERL=1 NO_PYTHON=1 NO_TCLTK=1
