#!/bin/sh
# Use gitk on Cygwin without X11
# Script I used to build Tk:
# github.com/svnpenn/etc/blob/master/install/tcl-tk/tk-dist.sh

# Install Tk
wget github.com/downloads/svnpenn/etc/tk-8.5.13.tar.gz
tar xf tk-8.5.13.tar.gz
cp -r usr /

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
wget raw.github.com/svnpenn/etc/master/install/gitk/wish
chmod +x gitk wish
