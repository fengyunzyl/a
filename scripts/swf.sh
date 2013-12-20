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

gemi ()
{
  git clone --depth 1 git://github.com/$1/$2
  cd $2
  gem build $2.gemspec
  gem install $2
}

[ $1 ] || usage
arg_file=$1
hash gem || log setup -nqP ruby
hash furnace-swf || gemi whitequark furnace-swf
hash furnace-avm2 || gemi whitequark furnace-avm2

log furnace-swf -i $arg_file abclist |
  tee /dev/tty | cut -s -d'"' -f2 | while read aa
do
  log furnace-swf -i $arg_file abcextract -n "$aa" -o a.abc
  log furnace-avm2 -i a.abc -d -o b.abc
  log furnace-avm2-decompiler -i b.abc -d -D funids > $aa.as
done

rm a.abc b.abc
