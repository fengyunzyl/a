#!/bin/sh
type sage >/dev/null || exit
# automake < autoreconf
# bison < yacc < make
# diffutils < cmp < configure
# flex < make
# libtool < autoreconf
# mingw64-x86_64-gcc-core < x86_64-w64-mingw32-gcc < configure
sage install automake bison diffutils flex libtool \
  make mingw64-x86_64-gcc-core upx zip
sage install --nodeps git
# need full clone for autoreconf
git clone --single-branch git://github.com/stedolan/jq
cd jq
git pull origin pull/939/head
autoreconf --install
./configure --host x86_64-w64-mingw32
make --jobs 4 LDFLAGS='-s -lshlwapi'
upx -9 jq.exe
vr=$(./jq --version | sed :)
zip -9 "$vr".zip jq.exe
