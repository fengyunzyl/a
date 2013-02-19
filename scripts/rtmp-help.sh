#!/bin/bash

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

clean ()
{
  rm -f a.core a.txt
}

pgrep ()
{
  ps -W | grep $1 | cut -c-9
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

usage ()
{
  echo "usage: $0 DELAY"
  exit
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

[ $1 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
coredump $1 plugin-container
warn 'Press enter to start RtmpDumpHelper, then restart video.'
read

grep -Eaom1 '(RTMP|rtmp).{0,2}://[-.:0-9A-Za-z]+' a.core |
  cut -d: -f3 > a.txt

read < a.txt
# Be careful adding ports here, can block RTMPT
echo "[general]
autorunproxyserver=0
captureportslist=1935 $REPLY
usecaptureportslist=1" > /usr/local/bin/rtmpdumphelper.cfg
rtmpsuck -et
read da < rtmpsuck.txt

tr "[:cntrl:]" "\n" < a.core |
  grep -1m1 secureTokenResponse |
  tac > a.txt

read dt < a.txt
rm a.core a.txt
eval rtmp-opt.sh $da ${dt:+-T $dt}
