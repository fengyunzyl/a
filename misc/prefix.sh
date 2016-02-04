#!/bin/sh
# get compiler prefix
warn() {
  printf '\033[36m%s\033[m\n' "$*"
}

if [ $# != 1 ]
then
  echo 'prefix.sh [compiler]'
  exit
fi

touch foo.c

warn INCLUDE
$1 -v foo.c |& egrep '^ [^ ]+$' | while read -r ic
do
  if [ -a $ic ]
  then
    cd $ic
    until ! [[ $PWD =~ include ]]
    do
      cd ..
    done
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort -u

warn LIB
$1 -\#\#\# foo.c |& sed '
/LIBRARY_PATH=/!d
s///
y/:/\n/
' |
while read -r lb
do
  if [ -a $lb ]
  then
    cd $lb
    until ! [[ $PWD =~ lib ]]
    do
      cd ..
    done
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort -u

rm -f foo.c foo.o
