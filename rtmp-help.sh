#!/bin/bash
# Download with RtmpDumpHelper

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

pc=plugin-container
killall $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'This script requires RtmpSrv v2.4-46 or higher.
Killed flash player for clean dump.
Restart video then press enter here.'
until read < <(pidof $pc); do warn "$pc not found!"; done
rm -f pg.core
dumper pg $REPLY &
until [ -s pg.core ]; do sleep 1; done
warn 'Press enter to start RtmpDumpHelper, then restart video.'
[ -a rtmpsrv ] && mv rtmpsrv /usr/local/bin
[ -a rtmpdumphelper ] && mv rtmpdumphelper{,.dll} /usr/local/bin
echo '[general]
autorunproxyserver=0' > /usr/local/bin/rtmpdumphelper.cfg
rtmpdumphelper &
read < <(rtmpsrv -i)
declare -a aa="($REPLY)"
declare -A ab
while getopts "C:W:a:f:o:p:r:y:" opt "${aa[@]:1}"; do ab[$opt]="$OPTARG"; done

tr "[:cntrl:]" "\n" < pg.core |
  grep -1m1 secureTokenResponse |
  tac |
  tee tp

read ab[T] < tp
rm pg.core tp
set -x
rtmpdump -o a.flv -r "${ab[r]}" ||
rtmpdump -o a.flv -r "${ab[r]}" -y "${ab[y]}" ||
rtmpdump -o a.flv -r "${ab[r]}" -a "${ab[a]}" -y "${ab[y]}" ||
rtmpdump -o a.flv -r "${ab[r]}" -y "${ab[y]}" -T "${ab[T]}" -W "${ab[W]}" ||
rtmpdump -o a.flv -r "${ab[r]}" -y "${ab[y]}" -T "${ab[T]}" -p "${ab[p]}"
