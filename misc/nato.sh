#!/bin/sh

if [ $# = 0 ]
then
  echo 'nato.sh [words per line]'
  exit
fi

z=$1

y=(
  al-pha bra-vo char-lie del-ta ech-o fox-trot golf ho-tel in-di-a ju-li-et
  ki-lo li-ma mike no-vem-ber os-car pa-pa que-bec ro-me-o si-er-ra tan-go
  u-ni-form vic-tor whis-key x-ray yan-kee zu-lu
)

for x in ${!y[*]}
do
  echo ${y[*]:x:z}
done
