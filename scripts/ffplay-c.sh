#!/bin/sh
# FFplay with cookies

usage ()
{
  echo "usage:  ${0##*/} COOKIE URL"
  echo
  echo "example cookie:  sbsession=sbg&sbuser=lorem"
  exit
}

[ $1 ] || usage

ffplay -headers "Cookie: $1"$'\r\n' "$2"
