#!/bin/bash

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

warn(){
  echo -e "\e[1;35m$1\e[m"
  read
}

pidof(){
  ps -W | grep $1 | cut -c-9
}

killall(){
  pidof $1 | xargs /bin/kill -f
}

hs=$WINDIR/system32/drivers/etc/hosts
pc=plugin-container
killall $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
> $hs
warn 'Killed flash player for clean dump. Hosts file reset.
Restart video then press enter here.'
read < <(pidof $pc) || die "$pc not found!"
rm -f pg.core
dumper pg $REPLY &
until [ -s pg.core ]; do sleep 1; done

LANG= grep -Eao '(RTMP|rtmp).{0,2}://[-.0-z]+' pg.core \
  | tee tp \
  | tr -d / \
  | cut -d: -f2 \
  | sort -u \
  | sed 's,^,127.0.0.1 ,' \
  | tee $hs

warn 'Press enter to start RtmpSrv, then restart video.'
IFS=: read _ _ RTMPPORT < tp
export RTMPPORT
read rp < <(rtmpsrv | grep -m1 rtmpdump)
# mapfile -t < <(grep -1Um1 rtmpdump <&$r)
# Restart video
killall rtmpdump
killall rtmpsrv
> $hs

tr "[:cntrl:]" "\n" < pg.core \
  | grep -1m1 secureTokenResponse \
  | tac \
  | tee tp

read < tp && rp+=" -T '$REPLY'"
rm pg.core tp
echo $rp
eval $rp
