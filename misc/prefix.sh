#!/bin/sh
# get compiler prefix
if [ $# != 1 ]
then
  echo 'prefix.sh [compiler]'
  exit
fi
qu=$1

touch /tmp/ro.c

echo INCLUDE
$qu -v /tmp/ro.c 2>&1 | egrep '^ [^ ]+$' |
while read -r si
do
  if [ -d $si ]
  then
    cd $si
    while echo $PWD | grep -q include
    do
      cd ..
    done
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort -u

echo LIB
$qu '-###' /tmp/ro.c 2>&1 | sed '
/LIBRARY_PATH=/!d
s///
y/:/\n/
' |
while read -r ta
do
  if [ -d $ta ]
  then
    cd $ta
    while echo $PWD | grep -q lib
    do
      cd ..
    done
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort -u
