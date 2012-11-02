#!/bin/sh
# wiki.tcl.tk/14828
# Installs to 
# /usr/local/bin/tclsh85.exe
# /usr/local/bin/wish85.exe

read <<< 8.5.11

# Install Tcl
wget prdownloads.sf.net/tcl/tcl$REPLY-src.tar.gz
tar xf tcl$REPLY-src.tar.gz
cd tcl$REPLY/win
./configure
make install
cd -

# Install Tk
wget prdownloads.sf.net/tcl/tk$REPLY-src.tar.gz
tar xf tk$REPLY-src.tar.gz
cd tk$REPLY/win
./configure
make install
cd -
