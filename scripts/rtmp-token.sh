#!/bin/bash
# Get SecureToken to be used by RtmpDump

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

usage ()
{
  echo "usage: $0 DELAY"
  exit
}

clean ()
{
  rm -f a.core a.txt
}

pkill ()
{
  pgrep $1 | xargs kill -f
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

warn ()
{
  printf '\e[1;35m%s\e[m\n' "$*"
}

[ $1 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
coredump $1 plugin-container

tr "[:cntrl:]" "\n" < a.core |
  grep -1m1 secureTokenResponse |
  tac > a.txt

read dt < a.txt
rm a.core a.txt
[[ $dt ]] && echo $dt || echo 'SecureToken not found.'
