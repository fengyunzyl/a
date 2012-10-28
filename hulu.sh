#!/bin/bash

warn(){
  echo -e "\e[1;35m$1\e[m"
  read rp
}

pgrep(){
  ps -W | awk /$1/'{print$4;exit}'
}

pkill(){
  pgrep $1 | xargs kill -f
}

pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
until read < <(pgrep $pc); do warn "$pc not found!"; done
rm -f pg.core
dumper pg $REPLY &
until [ -s pg.core ]; do sleep 1; done
mapfile vids < <(grep -aoz "<video [^>]*>" pg.core | sort | uniq -w123)
rm pg.core
declare -A attr

for i in "${!vids[@]}"; do
  IFS=\" read -a vid <<< "${vids[i]}"
  j=0
  while [[ "${vid[j]}" =~ \ ([^=]*) ]]; do
    read ${BASH_REMATCH[1]//[-:]}[i] <<< "${vid[j+1]}"
    ((j+=2))
  done
  printf "%2d\t%9s\t%s\n" "$i" "${filetype[i]}" "${cdn[i]}"
done

warn 'Make choice. Avoid level3.'
set -x
rtmpdump \
  -o a.flv \
  -W http://download.hulu.com/huludesktop.swf \
  -r "${server[rp]}" \
  -y "${stream[rp]}" \
  -a "${server[rp]#*//*/}?${token[rp]//amp;}"
