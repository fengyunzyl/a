#!/bin/bash

binparse(){
  grep -Eaozm1 "$1" pg.core
}

pidof(){
  ps -W | awk /$1/'{print$4;exit}'
}

warn(){
  echo -e "\e[1;35m$1\e[m"
  read
}

killall(){
  pidof $1 | xargs kill -f
}

ab=/opt/Scripts/AdobeHDS.php
pc=plugin-container
killall $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
until read < <(pidof $pc); do warn "$pc not found!"; done
rm -f pg.core
dumper pg $REPLY &
until [ -s pg.core ]; do sleep 1; done
read ah < <(binparse "pvtoken.*")
read mn < <(binparse "http[^?]*f4m(\?|$)[^']*")
read ur < <(binparse "Mozilla/5.0.*")
rm pg.core
set -x
php "$ab" --manifest "$mn" ||
php "$ab" --manifest "$mn" --auth "$ah" --useragent "$ur"
