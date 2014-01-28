# get compiler prefix

usage () {
  echo usage: ${0##*/} COMPILER
  exit
}

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

(( $# )) || usage
touch foo.c

warn INCLUDE
$1 -v foo.c |& grep '^ [^ ]*$' | while read -r ic
do
  if [ -a $ic ]
  then
    cd $ic/..
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort

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
    cd $lb/..
    pwd
  fi
done | sed '
/\./d
s/^/--prefix /
' | sort -u

rm -f foo.c foo.o
