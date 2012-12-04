#!/bin/sh
# Use gitk on Cygwin without X11

# Install Tk
wget github.com/downloads/svnpenn/etc/tk-8.5.12.tar.gz
tar xf tk-8.5.12.tar.gz
cp -r usr /

# Install gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
wget raw.github.com/svnpenn/etc/master/install/gitk/wish
chmod +x gitk wish
