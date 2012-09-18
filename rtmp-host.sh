#!/bin/bash
/\\ 2>/dev/null
h=\\windows/system32/drivers/etc/hosts
p=plugin-container.exe

pidof(){
  ps -W | grep "$1" | cut -c-9
}

warn(){
  echo -e "\e[1;35m$1\e[m"
  read
}

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 >\\windows/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here'
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
  | xargs printf "127.0.0.1 %s\n" \
  | tee $h

warn 'Press enter to start RtmpSrv, then restart video.'
IFS=: read _ _ RTMPPORT < ports
export RTMPPORT
coproc r (rtmpsrv)

while read incantation; do
  expr "${!_}" : rtmpdump && break
done <&${r[0]}

echo q >&${r[1]}
pidof rtmpdump | xargs /bin/kill -f
> $h

# Get SecureToken
read < <(tr "[:cntrl:]" "\n" < p.core | grep -1m1 secureTokenResponse | tac)
rm p.core ports
echo "$incantation ${REPLY:+-T '$REPLY'}"
eval "$_"
