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
