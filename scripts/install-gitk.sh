# Use gitk on Cygwin without X11

# Tcl
wget downloads.sf.net/tcl/tcl8.6.0-src.tar.gz
tar xf tcl8.6.0-src.tar.gz
cd tcl8.6.0/win
./configure --host i686-w64-mingw32 --disable-shared
make -j5 binaries install-libraries TCL_EXE=:
cd -

# Tk
wget downloads.sf.net/tcl/tk8.6.0-src.tar.gz
tar xf tk8.6.0-src.tar.gz
cd tk8.6.0/win
./configure --host i686-w64-mingw32 --disable-shared
make -j5 install-binaries install-libraries

# gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
chmod +x gitk
echo '
gitk ()
{
  run wish86s /cygwin/usr/local/bin/gitk
  exit
}
' >> ~/.bash_profile
