#!/bin/dash -e
# github.com/cygwinports/lz4/blob/master/lz4.cygport
git clone git://github.com/svnpenn/mp4v2
cd mp4v2
autoreconf --install --verbose
./configure --host i686-w64-mingw32
make --jobs 5 LDFLAGS='-s -all-static' \
  DEFS='-DMP4V2_USE_STATIC_LIB -D__STDC_CONSTANT_MACROS'
# FIXME doc
q=$(git describe --tags)
zip mp4v2-$q.zip *.exe
hub release create -a *.zip $q
