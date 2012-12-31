#!/bin/bash
# FIXME check for RtmpSrv RtmpDumpHelper on PATH
# FIXME NetStream.Play.Reset..description..(Playing and resetting
#   mosaiktv/20121210

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

pc=plugin-container
pkill $pc
pkill rtmpdumphelper
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'This script requires RtmpSrv v2.4-46 or higher.
Killed flash player for clean dump.
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

warn 'Press enter to start RtmpDumpHelper, then restart video.'
read

LANG= grep -Eaom1 '(RTMP|rtmp).{0,2}://[-.0-z]+' pg.core |
  cut -d: -f3 > tp

read < tp
# Be careful adding ports here, can block RTMPT
echo "[general]
autorunproxyserver=0
captureportslist=1935 $REPLY
usecaptureportslist=1" > /usr/local/bin/rtmpdumphelper.cfg
rtmpsuck -et
read da < rtmpsuck.txt

tr "[:cntrl:]" "\n" < pg.core |
  grep -1m1 secureTokenResponse |
  tac > tp

read dt < tp
rm pg.core tp
eval rtmp-opt.sh $da ${dt:+-T $dt}
