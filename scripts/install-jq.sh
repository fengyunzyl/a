# up to date Windows native jq
setup -nqP bison
setup -nqP flex
setup -nqP python

git clone --depth 1 git://github.com/stedolan/jq.git
cd jq
make CC=i686-w64-mingw32-gcc

# archive
cd ${0%/*}
VERSION=$(git log --follow --oneline $0 | wc -l)
cd -
zip jq-${VERSION}.zip jq.exe
