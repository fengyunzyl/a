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
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
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
[ $2 ] || set , "$1"
log furnace-swf -i "$2" abclist
[ $1 = , ] && exit
log furnace-swf -i "$2" abcextract -n "$1" -o a.abc
log furnace-avm2 -i a.abc -d -o b.abc
log furnace-avm2-decompiler -i b.abc -d -D funids > a.as
clean
