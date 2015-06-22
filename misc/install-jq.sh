#!/bin/sh
type apt-cyg >/dev/null || exit
# automake > autoreconf
# diffutils > cmp > configure
# libtool > autoreconf
# mingw64-x86_64-gcc-core > x86_64-w64-mingw32-gcc > configure
apt-cyg install automake curl diffutils libtool \
  make mingw64-x86_64-gcc-core upx zip
apt-cyg install --nodeps git
# need full clone for autoreconf
git clone --single-branch git://github.com/stedolan/jq
cd jq
curl https://github.com/stedolan/jq/commit/97a2f34.diff | git apply
autoreconf --install
./configure --host x86_64-w64-mingw32
make --jobs 4 LDFLAGS=-s
upx -9 jq.exe
set -o igncr
vr=$(./jq --version)
zip -9 "$vr".zip jq.exe
