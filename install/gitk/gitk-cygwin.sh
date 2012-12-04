#!/bin/sh
# Use gitk on Cygwin without X11

# Install Tcl/Tk
wget github.com/downloads/svnpenn/etc/tcl-tk-8.5.12.tar.gz
tar xf tcl-tk-8.5.12.tar.gz
cp -r usr /

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
chmod +x gitk
