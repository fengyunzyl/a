#!/bin/sh
# This installs Git, Perl (git-send-email), TclTk (gitk)

# Install dependencies
mingw-get install libiconv
mingw-get install libz # git status
mingw-get install msys-perl # git send-email
mingw-get install msys-unzip
mingw-get install msys-wget

# Install OpenSSH
mingw-get install msys-openssh
cd /bin
cp msys-crypto* /usr/local/bin
cp msys-minires* /usr/local/bin
cp ssh.exe /usr/local/bin
cd -

# Install Tcl
wget prdownloads.sf.net/tcl/tcl8.5.11-src.tar.gz
tar xf tcl*
cd tcl*/win
./configure
make install TCLSH=tclsh.exe
cd -

# Install Tk
wget prdownloads.sf.net/tcl/tk8.5.11-src.tar.gz
tar xf tk*
cd tk*/win
./configure
make install WISH=wish.exe
cd -

# We need msysgit for the "hide dot files"
wget github.com/msysgit/git/tarball/master
tar xf msysgit*
cd msysgit*
# Build "git" and "gitk". Smaller without "THIS_IS_MSYSGIT".
make install prefix=/usr/local LDFLAGS=-static NO_OPENSSL=1 NO_GETTEXT=1
