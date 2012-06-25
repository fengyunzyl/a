#!/bin/sh
# linuxsampler.org/msys

# Install dependencies
mingw-get install msys-unzip
mingw-get install msys-wget

# Install intltool
wget 'ftp.gnome.org/pub/gnome/sources/intltool/0.40/intltool-0.40.6.tar.bz2'
tar xf intltool*
cd intltool*
./configure
make install
# /usr/local/bin/intltool-update