#!/bin/sh

# Install dependencies
mingw-get install libintl
mingw-get install msys-unzip
mingw-get install msys-wget

# Install Glib
wget 'ftp.gnome.org/pub/gnome/binaries/win32/glib/2.28/glib_2.28.8-1_win32.zip'
unzip glib* -d glib
cd glib
cp -r bin /mingw
cd -

# Install intl.dll
cd /mingw/bin
ln -s libintl-8.dll intl.dll
cd -

# Install pkg-config
wget ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.26-1_win32.zip
unzip pkg-config* -d pkg-config
cd pkg-config
cp -r bin /mingw