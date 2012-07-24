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

grep -aoz "rtmp[est]*://[.0-z]*/" p.core \
  | cut -d/ -f3 \
  | cut -d: -f1 \
  | sort -u \
  | xargs printf "127.0.0.1 %s\n" \
  | tee "$h"

red 'Press enter to start RtmpSrv, then restart video.'; read
coproc r (rtmpsrv)
while read; do grep rtmpdump <<< "$REPLY" && break; done <&${r[0]}
echo q >&${r[1]}

# Restore hosts file
> $h

# Run RtmpDump
pidof rtmpdump | xargs /bin/kill -f
eval "$REPLY||$REPLY -v"
