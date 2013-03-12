#!/bin/sh
# decompile and deobfuscate SWF
# http://github.com/whitequark/furnace-avm2
# http://canaldosconcursos.com.br/playercpf/player.swf
# http://www.zonytvcom.info/you/src.swf
# http://supremecater.com/player/src.swf

usage()
{
  echo usage: $0 [ABC_TAG_NAME] FILE
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

quote ()
{
  yy='[ #&;\]'
  if [[ ${!1} =~ $yy ]]
  then
    read -r $1 <<< \"${!1}\"
  fi
}

log ()
{
  for oo
  do
    quote oo
    set -- "$@" $oo
    shift
  done
  warn $*
  eval $*
}

clean ()
{
  rm a.abc b.abc
}

[ $1 ] || usage
arg_file=$1

log furnace-swf -i $arg_file abclist | cut -s -d'"' -f2 | while read aa
do
  log furnace-swf -i $arg_file abcextract -n "$aa" -o a.abc
  log furnace-avm2 -i a.abc -d -o b.abc
  log furnace-avm2-decompiler -i b.abc -d -D funids > $aa.as
  clean
done
