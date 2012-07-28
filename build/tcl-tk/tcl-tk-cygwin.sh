#!/bin/sh
alternatives \
	--install /usr/bin/gcc.exe gcc /usr/bin/i686-pc-mingw32-gcc.exe 40 \
	--slave /usr/bin/ar.exe ar /usr/bin/i686-pc-mingw32-ar.exe \
	--slave /usr/bin/cc.exe cc /usr/bin/i686-pc-mingw32-gcc.exe \
	--slave /usr/bin/ranlib.exe ranlib /usr/bin/i686-pc-mingw32-ranlib.exe \
	--slave /usr/bin/windres.exe windres /usr/bin/i686-pc-mingw32-windres.exe

# Install Tcl
wget prdownloads.sf.net/tcl/tcl8.5.11-src.tar.gz
tar xf tcl*
cd tcl*/win
./configure
make install
cd -
# /usr/local/bin/tclsh85.exe

# Install Tk
wget prdownloads.sf.net/tcl/tk8.5.11-src.tar.gz
tar xf tk*
cd tk*/win
./configure
make install
# /usr/local/bin/wish85.exe
