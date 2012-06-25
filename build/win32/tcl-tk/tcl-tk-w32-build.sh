#!/bin/sh
# wiki.tcl.tk/14828
# This install requires MSYS Base System.
# I prefer this over installing MinGW Developer Toolkit.

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