#!/bin/sh
# http://git.savannah.gnu.org/cgit/tar.git/tree/src/suffix.c

usage ()
{
  echo "Usage:  ${0##*/} INPUT"
  exit
}

try ()
{
  unset gh
  for gg
    do
      [[ "$gg" =~ [\ \&] ]] && gg="\"$gg\""
      gh+=("$gg")
    done
  echo "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage

try tar acf a.tar.bz2 "$@"
try tar acf a.tar.gz "$@"
try tar acf a.tar.lzma "$@"
try tar acf a.tar.xz "$@"
