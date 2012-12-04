#!/bin/sh
# Minimal dist for Tk binary.
# We must build the Windows native Tk because Cygwin version requires X11. This
# script packages only that which is necessary for gitk to run.

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.13-src.tar.gz
tar xf tcl8.5.13-src.tar.gz
cd tcl8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared
make binaries
cd -

# Install Tk
wget downloads.sf.net/tcl/tk8.5.13-src.tar.gz
tar xf tk8.5.13-src.tar.gz
cd tk8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared
make install-binaries install-libraries INSTALL_ROOT=.

# Archive
cd usr/local/bin
# strip will decrease file size without increasing archive size
i686-w64-mingw32-strip wish85s
cd -
# threshold 100 KB.
tar acf tk-8.5.13.tar.gz \
  --exclude '*.a' \
  --exclude include \
  usr
