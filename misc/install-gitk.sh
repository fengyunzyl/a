# Use gitk on Cygwin without X11
pk=(
  mingw-w64-x86_64-tcl
  mingw-w64-x86_64-tk
  mingw-w64-x86_64-zlib
)
apt-msys2 install ${pk[*]}

# gitk
cd /var/cache
wget -nc github.com/git/git/raw/master/gitk-git/gitk
install gitk /bin