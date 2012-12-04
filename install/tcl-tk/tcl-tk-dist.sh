#!/bin/sh
# Minimal dist for Tcl/Tk binary.
# We must build the Windows native Tcl/Tk because Cygwin version requires X11.
# To that end, we must use native paths. This script packages only that which
# is necessary for gitk to run.

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.13-src.tar.gz
tar xf tcl8.5.13-src.tar.gz
cd tcl8.5.13/win
./configure --host i686-w64-mingw32
make binaries
cd -

# Install Tk
wget downloads.sf.net/tcl/tk8.5.13-src.tar.gz
tar xf tk8.5.13-src.tar.gz
cd tk8.5.13/win
./configure --host i686-w64-mingw32 --disable-shared \
  --prefix $HOMEDRIVE/usr/local
rm -rf $HOMEDRIVE/usr
make install-binaries install-libraries

# Archive
cd $HOMEDRIVE/usr/local/bin
# strip will decrease file size without increasing archive size
i686-w64-mingw32-strip wish85s
cd $HOMEDRIVE
# threshold 100 KB.
tar acf tcl-tk-8.5.13.tar.gz \
  --exclude '*.a' \
  --exclude include \
  usr
