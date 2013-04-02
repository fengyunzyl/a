# cygwin jq
setup -nqP bison,flex,gcc4-core,git,make,mpfr,python
git clone --depth 1 git://github.com/stedolan/jq.git
cd jq
make

# archive
cd ${0%/*}
BABY_VERSION=$(git log --follow --oneline $0 | wc -l)
cd -
P7ZIP="${ProgramW6432}/7-zip/7z"
"$P7ZIP" a -mx=9 jq-cygwin-${BABY_VERSION}.zip jq.exe
