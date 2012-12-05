#!/bin/sh
# Minimal dist for Tcl library.
# We must build the Windows native Tcl because Cygwin version requires X11. This
# script packages only that which is necessary for gitk to run. 

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.13-src.tar.gz
tar xf tcl8.5.13-src.tar.gz
cd tcl8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared
make binaries install-libraries INSTALL_ROOT=.

# Archive
# threshold 100 KB.
tar acf tcl-8.5.13.tar.gz \
  --exclude encoding \
  --exclude include \
  --exclude msgs \
  --exclude tzdata \
  usr
