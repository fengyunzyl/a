# Use gitk on Cygwin without X11
mr=http://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64

# tcl tk zlib
cd /var/cache
for pc in tcl-8.6.1-3 tk-8.6.1-3 zlib-1.2.8-2
do
  av=mingw-w64-x86_64-$pc-any.pkg.tar.xz
  wget -nc $mr/$av
  tar xf $av
done
cd mingw64
cp -r bin lib /

# gitk
cd /bin
wget -nc github.com/git/git/raw/master/gitk-git/gitk
chmod +x gitk

echo '
gitk () {
  cygstart wish $(cygpath -m $(type -P gitk)) "$@"
}
' >> ~/.bashrc
