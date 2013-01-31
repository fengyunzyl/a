#!/bin/sh
# port script to convert paths
# existing file
# new file
# existing folder
# new folder

usage ()
{
  echo usage: $0 PATH
  exit
}

[ $1 ] || usage

if [ -a "$1" ]
then
  mv "$1" /tmp
fi

mkdir -p "$1"
cd "$1"
# unix path
pwd
cd ~-
rmdir "$1"
mv "/tmp/$1" .
