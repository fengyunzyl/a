#!/bin/sh
# We must build the Windows native Tcl/Tk because Cygwin version requires X11.
# To that end, we must use native paths. gitk requires part of Tcl but not the
# exe, so this just makes Tk dist. Tcl "make doc" doesnt do anything, but
# future versions might.
rm -rf $HOMEDRIVE/usr

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.12-src.tar.gz
tar xf tcl8.5.12-src.tar.gz
cd tcl8.5.12/win
./configure --host i686-w64-mingw32 --disable-shared \
  --prefix $HOMEDRIVE/usr/local
make install-binaries install-libraries
cd -

# Install Tk
wget downloads.sf.net/tcl/tk8.5.12-src.tar.gz
tar xf tk8.5.12-src.tar.gz
cd tk8.5.12/win
./configure --host i686-w64-mingw32 --disable-shared \
  --prefix $HOMEDRIVE/usr/local
make install-binaries install-libraries

# Archive
cd $HOMEDRIVE/usr/local/bin
# strip will decrease file size without increasing archive size
i686-w64-mingw32-strip wish85s
cd $HOMEDRIVE
# threshold 100 KB. This will leave some empty folders but so what.
tar acf tk-8.5.12.tar.gz \
  --exclude '*.a' \
  --exclude encoding \
  --exclude include \
  --exclude msgs \
  --exclude tclsh85s.exe \
  --exclude tzdata \
  usr
