#!/bin/sh

usage ()
{
  echo usage: $0 ROWS COLUMNS
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

# convert to hex
printf -v rows %04x $1
printf -v columns %04x $2
log regtool set /user/Console/ScreenBufferSize 0x$rows$columns
echo Restart console to see changes.
