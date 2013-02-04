#!/bin/sh
# portable script to convert paths
# existing file
# new file
# existing folder
# new folder

usage ()
{
  echo usage: $0 [WINDOWS] PATH
  exit
}

[ $1 ] || usage
[ $2 ] || set '' "$1"

if [ -a "$2" ]
then
  mv "$2" /tmp
fi

mkdir -p "$2"
cd "$2"

if [ $1 ]
then
  $WINDIR/system32/cmd /c cd
else
  pwd
fi

cd ~-
rmdir "$2"
mv "/tmp/$2" .
