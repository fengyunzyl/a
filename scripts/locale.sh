#!/bin/sh
# test command for locale portability

usage ()
{
  echo usage: $0 COMMAND
  exit
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  warn $*
  eval $*
}

[ $1 ] || usage

log LANG= $*
log LANG=en_US.CP850 $*
log LANG=en_US.UTF-8 $*
