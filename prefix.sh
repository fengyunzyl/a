# get compiler prefix

usage ()
{
  echo usage: $0 COMPILER
  exit
}

[ $1 ] || usage

touch foo.c

$1 -v foo.c |& grep '^ [^ ]*$' | while read -r b
do
  cd $b
  pwd
done | sed '/\./d; s./[^/]*$..; s/^/--prefix /'

rm -f foo.c foo.o
