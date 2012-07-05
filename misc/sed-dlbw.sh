#!/bin/sh
# grymoire.com/Unix/Sed.html

[ $1 ] || {
  echo "Delete line before word
    Usage: ${0##*/} FILE REGEX1 REGEX2"
  return
}

sed "
  /$2/ {
    N
    /\n$3/ D
  }
" "$1"
