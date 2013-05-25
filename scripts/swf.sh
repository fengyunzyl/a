# decompile and deobfuscate SWF
# http://github.com/whitequark/furnace-avm2

usage ()
{
  echo usage: $0 FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

[ $1 ] || usage
arg_file=$1

if ! [ -a /bin/gem ]
then
  log setup -nqP ruby
fi

if ! [ -a /bin/furnace-swf ]
then
  log gem install furnace-swf
fi

if ! [ -a /bin/furnace-avm2 ]
then
  log gem install furnace-avm2
fi

log furnace-swf -i $arg_file abclist |
  tee /dev/tty | cut -s -d'"' -f2 | while read aa
do
  log furnace-swf -i $arg_file abcextract -n "$aa" -o a.abc
  log furnace-avm2 -i a.abc -d -o b.abc
  log furnace-avm2-decompiler -i b.abc -d -D funids > $aa.as
done

rm a.abc b.abc
