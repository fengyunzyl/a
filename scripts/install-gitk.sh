#!/bin/sh
# Use gitk on Cygwin without X11

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.13-src.tar.gz
tar xf tcl8.5.13-src.tar.gz
cd tcl8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared
make binaries install-libraries INSTALL_ROOT=$HOMEDRIVE/cygwin
cd -

# Install Tk
wget downloads.sf.net/tcl/tk8.5.13-src.tar.gz
tar xf tk8.5.13-src.tar.gz
cd tk8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared
make install-binaries install-libraries

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
wget raw.github.com/svnpenn/a/master/scripts/gitk.sh
chmod +x gitk gitk.sh
