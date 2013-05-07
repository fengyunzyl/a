# up to date Windows native jq
setup -nqP bison,flex,python

git clone --depth 1 git://github.com/stedolan/jq.git
cd jq
make binaries PLATFORMS=win32

# archive
cd ${0%/*}
VERSION=$(git log --follow --oneline $0 | wc -l)
cd -
zip jq-${VERSION}.zip jq.exe
