#!/bin/sh
# Use gitk on Cygwin without X11
# Requires Cygwin packages: git, make, mingw64-i686-gcc-core, wget 

# Install Tcl
wget prdownloads.sf.net/tcl/tcl8.5.12-src.tar.gz
tar xf tcl8.5.12-src.tar.gz
cd tcl8.5.12/win
./configure --host i686-w64-mingw32
make install
cd -

# Install Tk
wget prdownloads.sf.net/tcl/tk8.5.12-src.tar.gz
tar xf tk8.5.12-src.tar.gz
cd tk8.5.12/win
./configure --host i686-w64-mingw32
make install
cd -

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
chmod 700 gitk
echo 'cygpath -m "$1" | xargs -I% wish85 % -- ${@:3}' > wish
cd -
