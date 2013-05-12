# get compiler prefix

usage ()
{
  echo usage: $0 COMPILER
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

[ $1 ] || usage
touch foo.c

warn INCLUDE
$1 -v foo.c |& grep '^ [^ ]*$' | while read -r b
do
  if [ -a $b ] 2>&-
  then
    cd $b
    pwd
  fi
done | sed '/\./d; s./[^/]*$..; s/^/--prefix /'

warn LIB
$1 -\#\#\# foo.c |& sed '/LIBRARY_PATH=/!d; s///; y/;/\n/' | while read -r b
do
  if [ -a $b ] 2>&-
  then
    cd $b
    pwd
  fi
done | sed '/\./d; s./[^/]*$..; s/^/--prefix /'

rm -f foo.c foo.o
