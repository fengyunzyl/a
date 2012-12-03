#!/bin/sh
# We must build the Windows native Tcl/Tk because Cygwin version requires X11.
# To that end, we must use native paths.
rm -rf /tmp

# Install Tcl
wget downloads.sf.net/tcl/tcl8.5.12-src.tar.gz
tar xf tcl8.5.12-src.tar.gz
cd tcl8.5.12/win
./configure --host i686-w64-mingw32 --disable-shared \
  --prefix $HOMEDRIVE/usr/local
make install
cd -

# Install Tk
wget downloads.sf.net/tcl/tk8.5.12-src.tar.gz
tar xf tk8.5.12-src.tar.gz
cd tk8.5.12/win
./configure --host i686-w64-mingw32 --disable-shared \
  --prefix $HOMEDRIVE/usr/local
make install-binaries install-libraries
cd -

# Install gitk
cd $HOMEDRIVE/usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
wget raw.github.com/svnpenn/dotfiles/master/bin/wish
chmod +x gitk wish
cd -

# Archive
cd /tmp
read < <(git-describe-remote.sh git/git)
# strip will decrease file size without increasing archive size
find -exec strip {} \;
tar acf gitk-$REPLY.tar.lzma usr/local/bin usr/local/lib/{tcl8,tcl8.5,tk8.5}
