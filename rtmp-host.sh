#!/bin/sh
h="${COMSPEC%\\*}/drivers/etc/hosts"
p="plugin-container.exe"

pid(){
  ps -W | grep "$1" | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

# Kill flash player
pid "$p" | xargs /bin/kill -f
# Disable protected mode, 32 and 64 bit Windows
printf "ProtectedMode=0" > "${COMSPEC%\\*}/Macromed/Flash/mms.cfg"
red 'Press enter after video starts'; read
# Dump flash player
pid "$p" | xargs dumper p &
sleep 1

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
