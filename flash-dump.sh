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
  printf "\e[1;35m%s\e[m\n" "$*"
}

pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
read

until read < <(pgrep $pc)
do
  warn "$pc not found!"
  read
done

rm -f pg.core
dumper pg $REPLY &

until [ -s pg.core ]
do
  sleep 1
done

kill %%
