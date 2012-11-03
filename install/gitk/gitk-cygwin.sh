#!/bin/sh
# Use gitk on Cygwin without X11
# Requires Cygwin packages: git, make, mingw64-i686-gcc-core, wget 

v=8.5.11

# Install Tcl
wget prdownloads.sf.net/tcl/tcl$v-src.tar.gz
tar xf tcl$v-src.tar.gz
cd tcl$v/win
./configure --host i686-w64-mingw32
make install
cd -

# Install Tk
wget prdownloads.sf.net/tcl/tk$v-src.tar.gz
tar xf tk$v-src.tar.gz
cd tk$v/win
./configure --host i686-w64-mingw32
make install
cd -

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
echo 'cygpath -m "$1" | xargs wish85' > wish
cd -
