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
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
}

[ $1 ] || usage

# convert to hex
printf -v rows %04x $1
printf -v columns %04x $2
set -- -f -t reg_dword
log reg add 'hkcu\console' -v WindowSize -d 0x0019$columns "$@"
log reg add 'hkcu\console' -v ScreenBufferSize -d 0x$rows$columns "$@"
echo Restart console to see changes.
