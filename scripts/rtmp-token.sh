#!/bin/bash
# Get SecureToken to be used by RtmpDump

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

rm -f a.core
dumper a $REPLY &

until [ -s a.core ]
do
  sleep 1
done

kill %%
tr "[:cntrl:]" "\n" < a.core |
  grep -1m1 secureTokenResponse |
  tac > tp

read dt < tp
rm a.core tp
[[ $dt ]] && echo $dt || echo 'SecureToken not found.'
