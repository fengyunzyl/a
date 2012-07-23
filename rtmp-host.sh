#!/bin/sh
h=\\windows/system32/drivers/etc/hosts
p=plugin-container.exe

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

tr "\0\"" "\n" < p.core \
  | grep -Eom1 "rtmp[est]*://[\.0-9a-z]{2,}" \
  | cut -d/ -f3 \
  | xargs printf "127.0.0.1 %s\n" \
  | tee "$h"

# Start monitoring
red 'Press enter to start RtmpSrv, then restart video.'; read
coproc r (rtmpsrv)

while read; do
  grep rtmpdump <<< "$REPLY" && break
done <&${r[0]}

echo q >&${r[1]}

# Restore hosts file
> "$h"

# Run RtmpDump
eval "$REPLY||$REPLY -v"
