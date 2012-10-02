#!/bin/bash
/\\ 2>/dev/null
f=/opt/Scripts/AdobeHDS.php
p=plugin-container.exe

binparse(){
  grep -azm1 "$1" p.core
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
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here'; read
read < <(pidof $p) || die "$p not found!"
timeout 1 dumper p $REPLY 2>/dev/null
IFS=? read _ a < <(binparse "Frag")
read m < <(binparse "^http.*f4m")
read u < <(binparse "Mozilla/5.0")
set -x
php "$f" --manifest "$m" && exit
php "$f" --manifest "$m" --auth "$a" && exit
php "$f" --manifest "$m" --auth "$a" --useragent "$u"
