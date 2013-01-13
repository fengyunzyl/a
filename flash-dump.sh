#!/bin/bash

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
}

usage ()
{
  echo "usage: $0 DELAY"
  exit
}

[ $1 ] || usage
pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Script will automatically continue after video is restarted.'

until read < <(pgrep $pc)
do
  sleep 1
done

sleep $1
rm -f a.core
dumper a $REPLY &

until [ -s a.core ]
do
  sleep 1
done

kill %%
