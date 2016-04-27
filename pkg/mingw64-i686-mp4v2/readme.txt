NAME
  mp4v2

REQUIRES
  automake git libtool make mingw64-i686-gcc-g++ zip

NOTES
  automake
    provides autoreconf

  git
    called by make.sh

  libtool
    called by autoreconf

  make
    called by make.sh

  mingw64-i686-gcc-g++
    provides i686-w64-mingw32-g++, called by configure

  zip
    called by make.sh
