#!/bin/bash
/\\ 2>/dev/null
h=\\windows/system32/drivers/etc/hosts
p=plugin-container

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

killall $p
echo ProtectedMode=0 >\\windows/system32/macromed/flash/mms.cfg
> $h
warn 'Killed flash player for clean dump. Hosts file reset.
Restart video then press enter here.'
read < <(pidof $p) || die "$p not found!"
rm -f p.core
dumper p $REPLY &
until [ -s p.core ]; do sleep 1; done

# Add better support for upper case RTMPE; grep -i is too slow
LANG= grep -Eaoz "rtmp[est]*://[-.0-z]+" p.core \
  | tee ports \
  | tr -d / \
  | cut -d: -f2 \
  | sort -u \
  | sed 's,^,127.0.0.1 ,' \
  | tee $h

warn 'Press enter to start RtmpSrv, then restart video.'
IFS=: read _ _ RTMPPORT < ports
export RTMPPORT
read incantation < <(rtmpsrv | grep -m1 rtmpdump)
# mapfile -t < <(grep -1Um1 rtmpdump <&$r)
# Restart video
killall rtmpsrv
> $h

# Get SecureToken
read < <(tr "[:cntrl:]" "\n" < p.core | grep -1m1 secureTokenResponse | tac)
rm p.core ports
echo "$incantation ${REPLY:+-T '$REPLY'}"
eval "$_"
