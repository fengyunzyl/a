# up to date Windows native jq
setup -nqP bison,flex,libtool

git clone --depth 1 git://github.com/stedolan/jq.git
cd jq
autoreconf -i
./configure --host i686-w64-mingw32
make

# archive
cd ${0%/*}
VERSION=$(git log --follow --oneline $0 | wc -l)
cd -
zip jq-${VERSION}.zip jq.exe
