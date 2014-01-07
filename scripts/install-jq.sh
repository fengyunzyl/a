# up to date Windows native jq
setup-x86 -nqP bison,flex,libtool

git clone --depth 1 git://github.com/stedolan/jq
cd jq
autoreconf -i
./configure --host i686-w64-mingw32
make
