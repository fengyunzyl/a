#!/bin/sh
# http://git.savannah.gnu.org/cgit/tar.git/tree/src/suffix.c
# 7z wins because it is smaller than these.

quote ()
{
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
}

usage ()
{
  echo usage: $0 INPUT
  exit
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=($oo)
  done
  echo ${pp[*]}
  eval ${pp[*]}
}

[ $1 ] || usage

log tar acf a.tar.bz2 "$@"
log tar acf a.tar.gz "$@"
log tar acf a.tar.lzma "$@"
log tar acf a.tar.xz "$@"
