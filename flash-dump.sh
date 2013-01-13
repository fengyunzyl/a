#!/bin/bash

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

clean ()
{
  rm -f a.core
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo "usage: $0 DELAY"
  exit
}

coredump ()
{
  pkill $2
  warn Killed $2 for clean dump.
  warn Script will automatically continue after $2 is restarted.
  until read < <(pgrep $2)
  do
    sleep 1
  done
  sleep $1
  clean
  dumper a $REPLY &
  until [ -s a.core ]
  do
    sleep 1
  done
  kill -13 %%
}

[ $1 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
coredump $1 plugin-container
