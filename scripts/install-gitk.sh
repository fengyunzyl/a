# Use gitk on Cygwin without X11

# tcl tk zlib
cd /var/cache
for pc in tcl-8.6.1-3 tk-8.6.1-3 zlib-1.2.8-2
do
  wget downloads.sf.net/msys2/mingw-w64-x86_64-$pc-any.pkg.tar.xz
  tar xf mingw-w64-x86_64-$pc-any.pkg.tar.xz
done
cd mingw64
cp -r bin lib /usr/local

# gitk
cd /usr/local/bin
wget raw.github.com/git/git/master/gitk-git/gitk
sed -i '3s/wish "/wish < "/' gitk
chmod +x gitk
