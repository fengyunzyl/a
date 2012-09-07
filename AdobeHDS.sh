#!/bin/bash
LANG=
p=plugin-container.exe

binparse(){
  grep -axzm1 "[ -~]*$1[ -~]*" p.core
}

pidof(){
  ps -W | grep $1 | cut -c-9
}

warn(){
  echo -e "\e[1;35m$1\e[m"
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
warn 'Press enter after video starts'; read
warn 'Printing results'
pidof $p | xargs timeout 1 dumper p
IFS=? read _ a < <(binparse "Frag")
read m < <(binparse "http.*f4m?")
read u < <(binparse "Mozilla/5.0")
set -x
php /opt/Scripts/AdobeHDS.php ${a:+--auth "$a"} --manifest "$m" \
  --useragent "$u"
