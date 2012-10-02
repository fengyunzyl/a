#!/bin/bash

binparse(){
  grep -azm1 "$1" a.core
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

realpath(){
  read $1 < <(cd ${!1}; pwd)
}

realpath WINDIR
f=/opt/Scripts/AdobeHDS.php
p=plugin-container.exe
killall $p
echo ProtectedMode=0 >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here'
read < <(pidof $p) || die "$p not found!"
rm -f a.core
dumper a $REPLY 2>/dev/null &
until [ -s a.core ]; do sleep 1; done
IFS=? read _ a < <(binparse "Frag")
read m < <(binparse "^http.*f4m")
read u < <(binparse "Mozilla/5.0")
rm a.core
set -x
php "$f" --manifest "$m" && exit
php "$f" --manifest "$m" --auth "$a" && exit
php "$f" --manifest "$m" --auth "$a" --useragent "$u"
