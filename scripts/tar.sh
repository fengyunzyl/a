#!/bin/sh
# http://git.savannah.gnu.org/cgit/tar.git/tree/src/suffix.c
# 7z wins because it is smaller than these.

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

usage ()
{
  echo "Usage:  ${0##*/} INPUT"
  exit
}

log ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  echo "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage

log tar acf a.tar.bz2 "$@"
log tar acf a.tar.gz "$@"
log tar acf a.tar.lzma "$@"
log tar acf a.tar.xz "$@"
