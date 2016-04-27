NAME
  FDK AAC

REQUIRES
  automake diffutils git libtool make mingw64-x86_64-gcc-g++

NOTES
  automake
    provides autoreconf, called by autogen.sh

  diffutils
    provides cmp, called by configure

  git
    called by mingw.sh

  libtool
    called by autoreconf, called by autogen.sh

  make
    called by mingw.sh

  mingw64-x86_64-gcc-g++
    provides x86_64-w64-mingw32-g++, called by configure
