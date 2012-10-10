#!/bin/bash
# Requires RtmpSrv v2.4-45 or higher

warn(){
  echo -e "\e[1;35m$1\e[m"
  read
}

pidof(){
  ps -W | awk /$1/'{print$4;exit}'
}

killall(){
  pidof $1 | xargs kill -f
}

hs=$WINDIR/system32/drivers/etc/hosts
pc=plugin-container
killall $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
> $hs
warn 'Killed flash player for clean dump. Hosts file reset.
Restart video then press enter here.'
until read < <(pidof $pc); do warn "$pc not found!"; done
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
export RTMPSRV='print only'
read rp < <(rtmpsrv)
> $hs

tr "[:cntrl:]" "\n" < pg.core \
  | grep -1m1 secureTokenResponse \
  | tac \
  | tee tp

read < tp && rp+=" -T '$REPLY'"
rm pg.core tp
echo $rp
eval $rp
