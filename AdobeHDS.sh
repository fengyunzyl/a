#!/bin/bash
LANG=
p=plugin-container.exe

binparse(){
  grep -axzm1 "[ -~]*$1[ -~]*" p.core
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
echo ProtectedMode=0 2>/dev/null >\\windows/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here'; read
read < <(pidof $p) || die "$p not found!"
timeout 1 dumper p $REPLY 2>/dev/null
IFS=? read _ a < <(binparse "Frag")
read m < <(binparse "http.*f4m?")
read u < <(binparse "Mozilla/5.0")
set -x
php /opt/Scripts/AdobeHDS.php ${a:+--auth "$a"} --manifest "$m" \
  --useragent "$u"
