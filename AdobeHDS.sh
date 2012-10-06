#!/bin/bash

binparse(){
  grep -azm1 "$1" pg.core
}

pidof(){
  ps -W | grep $1 | cut -c-9
}

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

warn(){
  echo -e "\e[1;35m$1\e[m"
  read
}

killall(){
  pidof $1 | xargs /bin/kill -f
}

ab=/opt/Scripts/AdobeHDS.php
pc=plugin-container
killall $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
read < <(pidof $pc) || die "$p not found!"
rm -f pg.core
dumper pg $REPLY &
until [ -s pg.core ]; do sleep 1; done
IFS=? read _ ah < <(binparse "Frag")
read mn < <(binparse "^http.*f4m")
read ur < <(binparse "Mozilla/5.0")
rm pg.core
set -x
php "$ab" --manifest "$mn" && exit
php "$ab" --manifest "$mn" --auth "$ah" && exit
php "$ab" --manifest "$mn" --auth "$ah" --useragent "$ur"
