# up to date Windows native jq

# autoconf  need for autoreconf
# automake  need for autoreconf > aclocal
# libtool   need for autoreconf > libtool
# bison     need for make
# flex      need for make
pacman -S autoconf automake bison flex libtool

git clone --depth 1 git://github.com/stedolan/jq
cd jq
autoreconf -i
./configure --host x86_64-w64-mingw32
make -j4
