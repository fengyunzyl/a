#!/bin/sh
h=\\windows/system32/drivers/etc/hosts
p=plugin-container

pidof(){
  ps -W | grep "$1" | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
red 'Press enter after video starts'; read
pidof $p | xargs timeout 1 dumper p

grep -Eaoz "rtmp[est]*://[.0-9a-z]*:[0-9]{3,}" p.core \
  | tee ports \
  | tr -d / \
  | cut -d: -f2 \
  | sort -u \
  | xargs printf "127.0.0.1 %s\n" \
  | tee $h

red 'Press enter to start RtmpSrv, then restart video.'; read
IFS=: read _ _ RTMPPORT < ports
export RTMPPORT
coproc r (rtmpsrv)
while read; do grep rtmpdump <<< "$REPLY" && break; done <&${r[0]}
echo q >&${r[1]}
> $h

# Run RtmpDump
pidof rtmpdump | xargs /bin/kill -f
# tr "[:cntrl:]" "\n" < p.core | grep -A1 -m1 secureTokenResponse | tail -1
eval "$REPLY||$REPLY -v"
rm p.core
