NAME
  jq

REQUIRES
  automake bison diffutils flex git libtool make mingw64-x86_64-gcc-core upx zip

NOTES
  automake
    provides autoreconf

  bison
    provides yacc, called by make

  diffutils
    provides cmp, called by configure

  flex
    called by make

  git
    called by mingw.sh

  libtool
    called by autoreconf

  make
    called by mingw.sh

  mingw64-x86_64-gcc-core
    provides x86_64-w64-mingw32-gcc, called by configure

  upx
    called by dist.sh

  zip
    called by dist.sh
